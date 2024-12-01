{ config, lib, pkgs, ... }:
let
  cfg = config.services.moosefs;

  mfsUser = if cfg.runAsUser then "moosefs" else "root";

  settingsFormat = let
    listSep = " ";
    allowedTypes = with lib.types; [ bool int float str ];
    valueToString = val:
        if lib.isList val then lib.concatStringsSep listSep (map (x: valueToString x) val)
        else if lib.isBool val then (if val then "1" else "0")
        else toString val;

    in {
      type = with lib.types; let
        valueType = oneOf ([
          (listOf valueType)
        ] ++ allowedTypes) // {
          description = "Flat key-value file";
        };
      in attrsOf valueType;

      generate = name: value:
        pkgs.writeText name ( lib.concatStringsSep "\n" (
          lib.mapAttrsToList (key: val: "${key} = ${valueToString val}") value ));
    };


  initTool = pkgs.writeShellScriptBin "mfsmaster-init" ''
    if [ ! -e ${cfg.master.settings.DATA_PATH}/metadata.mfs ]; then
      cp ${pkgs.moosefs}/var/mfs/metadata.mfs.empty ${cfg.master.settings.DATA_PATH}
      chmod +w ${cfg.master.settings.DATA_PATH}/metadata.mfs.empty
      ${pkgs.moosefs}/bin/mfsmaster -a -c ${masterCfg} start
      ${pkgs.moosefs}/bin/mfsmaster -c ${masterCfg} stop
      rm ${cfg.master.settings.DATA_PATH}/metadata.mfs.empty
    fi
  '';

  # master config file
  masterCfg = settingsFormat.generate
    "mfsmaster.cfg" cfg.master.settings;

  # metalogger config file
  metaloggerCfg = settingsFormat.generate
    "mfsmetalogger.cfg" cfg.metalogger.settings;

  # chunkserver config file
  chunkserverCfg = settingsFormat.generate
    "mfschunkserver.cfg" cfg.chunkserver.settings;

  # generic template for all daemons
  systemdService = name: extraConfig: configFile: {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network.target" "network-online.target" ];

    serviceConfig = {
      Type = "forking";
      ExecStart  = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} start";
      ExecStop   = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} stop";
      ExecReload = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} reload";
      PIDFile = "${cfg."${name}".settings.DATA_PATH}/.mfs${name}.lock";
    } // extraConfig;
  };

in {
  ###### interface

  options = {
    services.moosefs = {
      masterHost = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "IP or DNS name of master host.";
      };

      runAsUser = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Run daemons as user moosefs instead of root.";
      };

      client.enable = lib.mkEnableOption "Moosefs client";

      master = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Enable Moosefs master daemon.

            You need to run `mfsmaster-init` on a freshly installed master server to
            initialize the `DATA_PATH` directory.
          '';
          default = false;
        };

        exports = lib.mkOption {
          type = with lib.types; listOf str;
          default = null;
          description = "Paths to export (see mfsexports.cfg).";
          example = [
            "* / rw,alldirs,admin,maproot=0:0"
            "* . rw"
          ];
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open the necessary ports in the firewall.";
          default = false;
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/mfs";
              description = "Data storage directory.";
            };
          };

          description = "Contents of config file (mfsmaster.cfg).";
        };
      };

      metalogger = {
        enable = lib.mkEnableOption "Moosefs metalogger daemon";

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/mfs";
              description = "Data storage directory";
            };
          };

          description = "Contents of metalogger config file (mfsmetalogger.cfg).";
        };
      };

      chunkserver = {
        enable = lib.mkEnableOption "Moosefs chunkserver daemon";

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open the necessary ports in the firewall.";
          default = false;
        };

        hdds = lib.mkOption {
          type = with lib.types; listOf str;
          default =  null;
          description = "Mount points to be used by chunkserver for storage (see mfshdd.cfg).";
          example = [ "/mnt/hdd1" ];
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/mfs";
              description = "Directory for lock file.";
            };
          };

          description = "Contents of chunkserver config file (mfschunkserver.cfg).";
        };
      };
    };
  };

  ###### implementation

  config =  lib.mkIf ( cfg.client.enable || cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable ) {

    warnings = [ ( lib.mkIf (!cfg.runAsUser) "Running moosefs services as root is not recommended.") ];

    # Service settings
    services.moosefs = {
      master.settings = lib.mkIf cfg.master.enable {
        WORKING_USER = mfsUser;
        EXPORTS_FILENAME = toString ( pkgs.writeText "mfsexports.cfg"
          (lib.concatStringsSep "\n" cfg.master.exports));
      };

      metalogger.settings = lib.mkIf cfg.metalogger.enable {
        WORKING_USER = mfsUser;
        MASTER_HOST = cfg.masterHost;
      };

      chunkserver.settings = lib.mkIf cfg.chunkserver.enable {
        WORKING_USER = mfsUser;
        MASTER_HOST = cfg.masterHost;
        HDD_CONF_FILENAME = toString ( pkgs.writeText "mfshdd.cfg"
          (lib.concatStringsSep "\n" cfg.chunkserver.hdds));
      };
    };

    # Create system user account for daemons
    users = lib.mkIf ( cfg.runAsUser && ( cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable ) ) {
      users.moosefs = {
        isSystemUser = true;
        description = "moosefs daemon user";
        group = "moosefs";
      };
      groups.moosefs = {};
    };

    environment.systemPackages =
      (lib.optional cfg.client.enable pkgs.moosefs) ++
      (lib.optional cfg.master.enable initTool);

    networking.firewall.allowedTCPPorts =
      (lib.optionals cfg.master.openFirewall [ 9419 9420 9421 ]) ++
      (lib.optional cfg.chunkserver.openFirewall 9422);

    # Ensure storage directories exist
    systemd.tmpfiles.rules =
         lib.optional cfg.master.enable "d ${cfg.master.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}"
      ++ lib.optional cfg.metalogger.enable "d ${cfg.metalogger.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}"
      ++ lib.optional cfg.chunkserver.enable "d ${cfg.chunkserver.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}";

    # Service definitions
    systemd.services.mfs-master = lib.mkIf cfg.master.enable
    ( systemdService "master" {
      TimeoutStartSec = 1800;
      TimeoutStopSec = 1800;
      Restart = "no";
    } masterCfg );

    systemd.services.mfs-metalogger = lib.mkIf cfg.metalogger.enable
      ( systemdService "metalogger" { Restart = "on-abnormal"; } metaloggerCfg );

    systemd.services.mfs-chunkserver = lib.mkIf cfg.chunkserver.enable
      ( systemdService "chunkserver" { Restart = "on-abnormal"; } chunkserverCfg );
    };
}
