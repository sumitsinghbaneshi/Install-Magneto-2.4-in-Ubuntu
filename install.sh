#!/bin/bash

# Update package lists
sudo apt-get update

# Install Apache
echo "Installing Apache..."
sudo apt-get install -y apache2

# Install PHP7.4
echo "Installing PHP7.4..."
sudo apt-get install -y php7.4

# Install PHP extensions
echo "Installing PHP extensions..."
sudo apt-get install -y php7.4-extension bcmath ctype curl dom gd hash iconv intl mbstring openssl pdo_mysql simplexml soap xsl zip libxml

# Install MySQL 8.0
echo "Installing MySQL repositories..."
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.11-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.11-1_all.deb
sudo apt-get update

echo "Installing MySQL server..."
sudo apt-get install -y mysql-server

echo "Setting up MySQL security..."
sudo mysql_secure_installation

# Create database (replace 'db123pass' with your desired password)
echo "Creating database..."
sudo mysql -u root -p <<EOF
CREATE DATABASE ubuntu_dev;
GRANT ALL PRIVILEGES ON ubuntu_dev.* TO 'root'@'localhost' IDENTIFIED BY 'db123pass';
FLUSH PRIVILEGES;
EOF

# Install Composer
echo "Installing Composer..."
sudo apt-get install -y composer

# Install OpenJDK JAVA 11
echo "Installing OpenJDK JAVA 11..."

# Search OpenJDK packages (optional)
# sudo apt-cache search openjdk

# Install JAVA (OpenJDK)
sudo apt-get install -y openjdk-11-jre openjdk-11-jdk

# Check Java version
java -version

# Configure Default Java Version
echo "Setting JAVA_HOME..."
echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/' | sudo tee -a /etc/environment
source /etc/environment  # Reload environment variables (optional)

# Check JAVA_HOME
echo $JAVA_HOME

# Install Elasticsearch
echo "Installing Elasticsearch..."
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt install -y elasticsearch

# Configure Elasticsearch
echo "Configuring Elasticsearch..."
sudo nano /etc/elasticsearch/elasticsearch.yml  # Edit configuration as needed (refer to comments)
# (refer to comments in the script for configuration options)

# Check Elasticsearch
echo "Checking Elasticsearch..."
curl -XGET 'http://localhost:9200'
curl http://localhost:9200/_cluster/health?pretty

# Download Magento through composer
echo "Downloading Magento..."
sudo composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html

# Install Magento
echo "Installing Magento..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo php -dmemory_limit=-1 /var/www/html/bin/magento setup:install \
  --base-url="http://example.com/" \
  --session-save="files" \
  --db-host="localhost" \
  --db-name="ubuntu_dev" \
  --db-user="root" \
  --db-password="db123pass" \
  --admin-firstname="admin" \
  --admin-lastname="admin" \
  --admin-email="admin@admin.com" \
  --admin-user="admin" \
  --admin-password="admin" \
  --language="en_US" \
  --currency="USD" \
  --backend-frontname="admin"

# Final commands
echo "Running final commands..."
sudo php -dmemory_limit=-1 /var/www/html/bin/magento setup:upgrade
sudo php -dmemory_limit=-1 /var/www/html/bin/magento setup:static-content:deploy -f
sudo php -dmemory_limit=-1 /var/www/html/bin/


#written by://github.com/sumitsinghbaneshi