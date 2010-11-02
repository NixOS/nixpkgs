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

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.disnix ] ++ optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

    services.tomcat.enable = cfg.useWebServiceInterface;
    services.tomcat.extraGroups = [ "disnix" ];
    services.tomcat.javaOpts = "${optionalString cfg.useWebServiceInterface "-Djava.library.path=${pkgs.libmatthew_java}/lib/jni"} ";
    services.tomcat.sharedLibs = []
                                 ++ optional cfg.useWebServiceInterface "${pkgs.DisnixWebService}/share/java/DisnixConnection.jar"
				 ++ optional cfg.useWebServiceInterface "${pkgs.dbus_java}/share/java/dbus.jar";
    services.tomcat.webapps = [] ++ optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    users.extraGroups = singleton
      { name = "disnix";
        gid = config.ids.gids.disnix;
      };
      
    jobs.disnix =
      { description = "Disnix server";

        startOn = "started dbus";

        script =
          ''
	    export PATH=/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin
            export HOME=/root

            ${pkgs.disnix}/bin/disnix-service --activation-modules-dir=${disnix_activation_scripts}/libexec/disnix/activation-scripts
          '';
      };

  };

}
