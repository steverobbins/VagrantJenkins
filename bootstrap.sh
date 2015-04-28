#!/usr/bin/env bash

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get -y install jenkins

hostname 192.168.50.200.xip.io

/etc/init.d/jenkins start

aptitude -y install apache2
a2enmod proxy
a2enmod proxy_http

echo '<VirtualHost *:80>
  ServerName 192.168.50.200.xip.io
  ProxyRequests Off
  <Proxy *>
    Order deny,allow
    Allow from all
  </Proxy>
  ProxyPreserveHost on
  ProxyPass / http://localhost:8080/ nocanon
  AllowEncodedSlashes NoDecode
</VirtualHost>' > /etc/apache2/sites-available/jenkins.conf

unlink /etc/apache2/sites-enabled/000-default.conf

a2ensite jenkins
apache2ctl restart
