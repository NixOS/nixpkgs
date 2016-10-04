# Disnix server
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.disnix;

  dysnomia = pkgs.dysnomia.override (origArgs: {
    enableApacheWebApplication = config.services.httpd.enable;
    enableAxis2WebService = config.services.tomcat.axis2.enable;
    enableEjabberdDump = config.services.ejabberd.enable;
    enableMySQLDatabase = config.services.mysql.enable;
    enablePostgreSQLDatabase = config.services.postgresql.enable;
    enableSubversionRepository = config.services.svnserve.enable;
    enableTomcatWebApplication = config.services.tomcat.enable;
    enableMongoDatabase = config.services.mongodb.enable;
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
      
      package = mkOption {
        type = types.path;
        description = "The Disnix package";
        default = pkgs.disnix;
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    dysnomia.enable = true;
    
    environment.systemPackages = [ pkgs.disnix ] ++ optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

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

    systemd.services = {
      disnix = {
        description = "Disnix server";
        wants = [ "dysnomia.target" ];
        wantedBy = [ "multi-user.target" ];
        after = [ "dbus.service" ]
          ++ optional config.services.httpd.enable "httpd.service"
          ++ optional config.services.mysql.enable "mysql.service"
          ++ optional config.services.postgresql.enable "postgresql.service"
          ++ optional config.services.tomcat.enable "tomcat.service"
          ++ optional config.services.svnserve.enable "svnserve.service"
          ++ optional config.services.mongodb.enable "mongodb.service";

        restartIfChanged = false;

        path = [ config.nix.package cfg.package config.dysnomia.package "/run/current-system/sw" ];

        environment = {
          HOME = "/root";
        }
        // (if config.environment.variables ? DYSNOMIA_CONTAINERS_PATH then { inherit (config.environment.variables) DYSNOMIA_CONTAINERS_PATH; } else {})
        // (if config.environment.variables ? DYSNOMIA_MODULES_PATH then { inherit (config.environment.variables) DYSNOMIA_MODULES_PATH; } else {});
        
        serviceConfig.ExecStart = "${cfg.package}/bin/disnix-service";
      };

    };
  };
}
