# Disnix server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.disnix;
  
  disnix_activation_scripts = pkgs.disnix_activation_scripts.override (origArgs: {
    enableApacheWebApplication = config.services.httpd.enable;
    enableAxis2WebService = config.services.tomcat.axis2.enable;
    enableEjabberdDump = config.services.ejabberd.enable;
    enableMySQLDatabase = config.services.mysql.enable;
    enableTomcatWebApplication = config.services.tomcat.enable;
  });
in

{

  ###### interface
  
  options = {
  
    services.disnix = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable Disnix";
      };
      
      useWebServiceInterface = mkOption {
        default = false;
	description = "Whether to enable the DisnixWebService interface running on Apache Tomcat";
      };
      
      publishInfrastructure = {
        enable = mkOption {
          default = false;
	  description = "Whether to publish capabilities/properties of this machine in as attributes in the infrastructure option";
	};
	
	enableAuthentication = mkOption {
	  default = false;
	  description = "Whether to publish authentication credentials through the infrastructure attribute (not recommended in combination with Avahi)";
	};
      };            
      
      infrastructure = mkOption {
        default = {};
	description = "List of name value pairs containing properties for the infrastructure model";
      };
      
      publishAvahi = mkOption {
        default = false;
	description = "Whether to publish capabilities/properties as a Disnix service through Avahi";
      };

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.disnix ] ++ optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

    services.avahi.enable = cfg.publishAvahi;

    services.tomcat.enable = cfg.useWebServiceInterface;
    services.tomcat.extraGroups = [ "disnix" ];
    services.tomcat.javaOpts = "${optionalString cfg.useWebServiceInterface "-Djava.library.path=${pkgs.libmatthew_java}/lib/jni"} ";
    services.tomcat.sharedLibs = optional cfg.useWebServiceInterface "${pkgs.DisnixWebService}/share/java/DisnixConnection.jar"
				 ++ optional cfg.useWebServiceInterface "${pkgs.dbus_java}/share/java/dbus.jar";
    services.tomcat.webapps = optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    users.extraGroups = singleton
      { name = "disnix";
        gid = config.ids.gids.disnix;
      };
    
    services.disnix.infrastructure =
      optionalAttrs (cfg.publishInfrastructure.enable)
      ( { hostname = config.networking.hostName;
          targetHost = config.deployment.targetHost;
        }
        // optionalAttrs (config.nixpkgs.system != "") { system = config.nixpkgs.system; }
        // optionalAttrs (cfg.useWebServiceInterface) { targetEPR = "http://${config.deployment.targetHost}:8080/DisnixWebService/services/DisnixWebService"; }
        // optionalAttrs (config.services.httpd.enable) { documentRoot = config.services.httpd.documentRoot; }
        // optionalAttrs (config.services.mysql.enable) { mysqlPort = config.services.mysql.port; }
        // optionalAttrs (config.services.tomcat.enable) { tomcatPort = 8080; }
	// optionalAttrs (cfg.publishInfrastructure.enableAuthentication) (
          optionalAttrs (config.services.mysql.enable) { mysqlUsername = "root"; mysqlPassword = builtins.readFile config.services.mysql.rootPassword; }) 
	)
    ;
    
    jobs = {
      disnix =
        { description = "Disnix server";

          startOn = "started dbus";

          script =
          ''
	    export PATH=/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin
            export HOME=/root

            ${pkgs.disnix}/bin/disnix-service --activation-modules-dir=${disnix_activation_scripts}/libexec/disnix/activation-scripts
          '';
        };
    } // optionalAttrs cfg.publishAvahi {
      disnixAvahi =
        { description = "Disnix Avahi publisher";
      
          startOn = "started avahi-daemon";
	
	  exec =
          ''
            ${pkgs.avahi}/bin/avahi-publish-service disnix-$(${pkgs.nettools}/bin/hostname) _disnix._tcp 22 \
              "hostname=\"$(${pkgs.nettools}/bin/hostname)\"" \
	      "system=\"$(uname -m)-linux\"" \
	      "mem=$(grep 'MemTotal:' /proc/meminfo | sed -e 's/kB//' -e 's/MemTotal://' -e 's/ //g')" \
	      ${optionalString (cfg.useWebServiceInterface) ''"targetEPR=\"http://(${pkgs.nettools}/bin/hostname):8080/DisnixWebService/services/DisnixWebService\""''} \
              ${optionalString (config.services.httpd.enable) ''"documentRoot=\"${config.services.httpd.documentRoot}\""''} \
              ${optionalString (config.services.mysql.enable) ''"mysqlPort=3306"''} \
              ${optionalString (config.services.tomcat.enable) ''"tomcatPort=8080"''} \
              "supportedTypes=[$(for i in ${disnix_activation_scripts}/libexec/disnix/activation-scripts/*; do echo -n " \"$(basename $i)\""; done) ]" \
	      ${concatMapStrings (deploymentAttrName: let deploymentAttrValue = getAttr deploymentAttrName (config.deployment); in ''${deploymentAttrName}=\"${deploymentAttrValue}\" '' ) (attrNames (config.deployment))}
          '';
        };
    };
  };
}
