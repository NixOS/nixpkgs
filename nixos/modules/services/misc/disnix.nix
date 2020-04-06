# Disnix server
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.disnix;

in

{

  ###### interface

  options = {

    services.disnix = {

      enable = mkOption {
        default = false;
        description = "Whether to enable Disnix";
      };

      enableMultiUser = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to support multi-user mode by enabling the Disnix D-Bus service";
      };

      useWebServiceInterface = mkOption {
        default = false;
        description = "Whether to enable the DisnixWebService interface running on Apache Tomcat";
      };

      package = mkOption {
        type = types.path;
        description = "The Disnix package";
        default = pkgs.disnix;
        defaultText = "pkgs.disnix";
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

    users.groups.disnix.gid = config.ids.gids.disnix;

    systemd.services = {
      disnix = mkIf cfg.enableMultiUser {
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
