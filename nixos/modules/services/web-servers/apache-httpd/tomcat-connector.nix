{ config, pkgs, serverInfo, lib, ... }:

let
  extraWorkersProperties = lib.optionalString (config ? extraWorkersProperties) config.extraWorkersProperties;
  
  workersProperties = pkgs.writeText "workers.properties" ''
# Define list of workers that will be used
# for mapping requests
# The configuration directives are valid
# for the mod_jk version 1.2.18 and later
#
worker.list=loadbalancer,status

# Define Node1
# modify the host as your host IP or DNS name.
worker.node1.port=8009
worker.node1.host=localhost
worker.node1.type=ajp13
worker.node1.lbfactor=1

# Load-balancing behaviour
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=node1

# Status worker for managing load balancer
worker.status.type=status

${extraWorkersProperties}
  '';
in
{

  options = {
    extraWorkersProperties = lib.mkOption {
      default = "";
      description = "Additional configuration for the workers.properties file.";
    };
  };

  extraModules = [
    { name = "jk"; path = "${pkgs.tomcat_connectors}/modules/mod_jk.so"; }
  ];

  extraConfig = ''
# Where to find workers.properties
JkWorkersFile ${workersProperties}

# Where to put jk logs
JkLogFile ${serverInfo.serverConfig.logDir}/mod_jk.log

# Set the jk log level [debug/error/info]
JkLogLevel info

# Select the log format
JkLogStampFormat "[%a %b %d %H:%M:%S %Y]"

# JkOptions indicates to send SSK KEY SIZE
# Note: Changed from +ForwardURICompat.
# See http://tomcat.apache.org/security-jk.html
JkOptions +ForwardKeySize +ForwardURICompatUnparsed -ForwardDirectories

# JkRequestLogFormat
JkRequestLogFormat "%w %V %T"

# Mount your applications
JkMount /__application__/* loadbalancer

# You can use external file for mount points.
# It will be checked for updates each 60 seconds.
# The format of the file is: /url=worker
# /examples/*=loadbalancer
#JkMountFile uriworkermap.properties

# Add shared memory.
# This directive is present with 1.2.10 and
# later versions of mod_jk, and is needed for
# for load balancing to work properly
# Note: Replaced JkShmFile logs/jk.shm due to SELinux issues. Refer to
# https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225452
JkShmFile ${serverInfo.serverConfig.stateDir}/jk.shm

# Static files in all Tomcat webapp context directories are served by apache
JkAutoAlias /var/tomcat/webapps

# All requests go to worker by default
JkMount /* loadbalancer
# Serve some static files using httpd
#JkUnMount /*.html loadbalancer
#JkUnMount /*.jpg  loadbalancer
#JkUnMount /*.gif  loadbalancer
#JkUnMount /*.css  loadbalancer
#JkUnMount /*.png  loadbalancer
#JkUnMount /*.js  loadbalancer

# Add jkstatus for managing runtime data
<Location /jkstatus/>
JkMount status
Order deny,allow
Deny from all
Allow from 127.0.0.1
</Location>
  '';
}
