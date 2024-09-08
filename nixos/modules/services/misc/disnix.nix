# Disnix server
{ config, lib, pkgs, ... }:
let

  cfg = config.services.disnix;

in

{

  ###### interface

  options = {

    services.disnix = {

      enable = lib.mkEnableOption "Disnix";

      enableMultiUser = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to support multi-user mode by enabling the Disnix D-Bus service";
      };

      useWebServiceInterface = lib.mkEnableOption "the DisnixWebService interface running on Apache Tomcat";

      package = lib.mkPackageOption pkgs "disnix" {};

      enableProfilePath = lib.mkEnableOption "exposing the Disnix profiles in the system's PATH";

      profiles = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "default" ];
        description = "Names of the Disnix profiles to expose in the system's PATH";
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    dysnomia.enable = true;

    environment.systemPackages = [ pkgs.disnix ] ++ lib.optional cfg.useWebServiceInterface pkgs.DisnixWebService;
    environment.variables.PATH = lib.optionals cfg.enableProfilePath (map (profileName: "/nix/var/nix/profiles/disnix/${profileName}/bin" ) cfg.profiles);
    environment.variables.DISNIX_REMOTE_CLIENT = lib.optionalString (cfg.enableMultiUser) "disnix-client";

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

    services.tomcat.enable = cfg.useWebServiceInterface;
    services.tomcat.extraGroups = [ "disnix" ];
    services.tomcat.javaOpts = "${lib.optionalString cfg.useWebServiceInterface "-Djava.library.path=${pkgs.libmatthew_java}/lib/jni"} ";
    services.tomcat.sharedLibs = lib.optional cfg.useWebServiceInterface "${pkgs.DisnixWebService}/share/java/DisnixConnection.jar"
      ++ lib.optional cfg.useWebServiceInterface "${pkgs.dbus_java}/share/java/dbus.jar";
    services.tomcat.webapps = lib.optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    users.groups.disnix.gid = config.ids.gids.disnix;

    systemd.services = {
      disnix = lib.mkIf cfg.enableMultiUser {
        description = "Disnix server";
        wants = [ "dysnomia.target" ];
        wantedBy = [ "multi-user.target" ];
        after = [ "dbus.service" ]
          ++ lib.optional config.services.httpd.enable "httpd.service"
          ++ lib.optional config.services.mysql.enable "mysql.service"
          ++ lib.optional config.services.postgresql.enable "postgresql.service"
          ++ lib.optional config.services.tomcat.enable "tomcat.service"
          ++ lib.optional config.services.svnserve.enable "svnserve.service"
          ++ lib.optional config.services.mongodb.enable "mongodb.service"
          ++ lib.optional config.services.influxdb.enable "influxdb.service";

        restartIfChanged = false;

        path = [ config.nix.package cfg.package config.dysnomia.package "/run/current-system/sw" ];

        environment = {
          HOME = "/root";
        }
        // (lib.optionalAttrs (config.environment.variables ? DYSNOMIA_CONTAINERS_PATH) { inherit (config.environment.variables) DYSNOMIA_CONTAINERS_PATH; })
        // (lib.optionalAttrs (config.environment.variables ? DYSNOMIA_MODULES_PATH) { inherit (config.environment.variables) DYSNOMIA_MODULES_PATH; });

        serviceConfig.ExecStart = "${cfg.package}/bin/disnix-service";
      };

    };
  };
}
