{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.wildfly;
  wildfly = cfg.package;

  wildflyService = pkgs.stdenv.mkDerivation {
    name = "wildfly-server";
    builder = ./builder.sh;
    inherit wildfly;
    inherit (pkgs) su;
    inherit (cfg)
      enable
      cleanBoot
      serverDir
      user
      group
      userAdmin
      passwordAdmin
      initialHeapMem
      maxHeapMem
      initialMetaspaceSize
      maxMetaspaceSize
      wildflyConfig
      wildflyMode
      wildflyBind
      wildflyBindManagement
      ;
  };

  cleanupScript = pkgs.writeScript "wildfly-cleanup" ''
    #!${pkgs.bash}/bin/bash
    if [ "${toString cfg.cleanBoot}" == "1" ]; then
      rm -rf ${cfg.serverDir}
    fi
  '';

in

{

  ###### interface

  options = {

    services.wildfly = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Wildfly.";
      };

      package = lib.mkPackageOption pkgs "wildfly-24-0-0" {
        example = "wildfly-24-0-0";
      };

      cleanBoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Delete and install the server instance file location every time. No persistence.";
      };

      serverDir = lib.mkOption {
        description = "Location of the server instance files";
        default = "/opt/wildfly";
        type = lib.types.str;
      };

      user = lib.mkOption {
        default = "nobody";
        description = "User account under which Wildfly runs.";
        type = lib.types.str;
      };

      group = lib.mkOption {
        default = "nogroup";
        description = "Group account under which Wildfly runs.";
        type = lib.types.str;
      };

      userAdmin = lib.mkOption {
        default = "admin";
        description = "Admin user who does the web management of Wildfly.";
        type = lib.types.str;
      };

      passwordAdmin = lib.mkOption {
        default = "wildfly";
        description = "Password admin user who does the web management of Wildfly.";
        type = lib.types.str;
      };

      initialHeapMem = lib.mkOption {
        description = "Initial Heap memory.";
        default = "400M";
        type = lib.types.str;
      };

      maxHeapMem = lib.mkOption {
        description = "Max Heap memory.";
        default = "600M";
        type = lib.types.str;
      };

      initialMetaspaceSize = lib.mkOption {
        description = "Initial Metaspace size.";
        default = "100M";
        type = lib.types.str;
      };

      maxMetaspaceSize = lib.mkOption {
        description = "Max Metaspace size.";
        default = "300M";
        type = lib.types.str;
      };

      wildflyConfig = lib.mkOption {
        description = "Wildfly default config.";
        default = "standalone-full.xml";
        type = lib.types.str;
      };

      wildflyMode = lib.mkOption {
        description = "Wildfly default mode.";
        default = "standalone";
        type = lib.types.str;
      };

      wildflyBind = lib.mkOption {
        description = "Wildfly bind address.";
        default = "0.0.0.0";
        type = lib.types.str;
      };

      wildflyBindManagement = lib.mkOption {
        description = "Wildfly bind management address.";
        default = "127.0.0.1";
        type = lib.types.str;
      };

    };

  };

  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      systemd.services.wildfly = {
        description = "WildFly Application Server";
        script = "${wildflyService}/bin/control";
        wantedBy = [ "multi-user.target" ];
      };
    })

    (lib.mkIf ((!cfg.enable) && cfg.cleanBoot) {
      system.activationScripts.wildflyCleanup = {
        text = ''
          ${cleanupScript}
        '';
        deps = [ ];
      };
    })
  ];

}
