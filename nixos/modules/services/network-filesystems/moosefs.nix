{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.moosefs;

  mfsUser = if cfg.runAsUser then "moosefs" else "root";

  settingsFormat = let
    listSep = " ";
    allowedTypes = with types; [ bool int float str ];
    valueToString = val:
        if isList val then concatStringsSep listSep (map (x: valueToString x) val)
        else if isBool val then (if val then "1" else "0")
        else toString val;

    in {
      type = with types; let
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
      masterHost = mkOption {
        type = types.str;
        default = null;
        description = lib.mdDoc "IP or DNS name of master host.";
      };

      runAsUser = mkOption {
        type = types.bool;
        default = true;
        example = true;
        description = lib.mdDoc "Run daemons as user moosefs instead of root.";
      };

      client.enable = mkEnableOption (lib.mdDoc "Moosefs client.");

      master = {
        enable = mkOption {
          type = types.bool;
          description = lib.mdDoc ''
            Enable Moosefs master daemon.

            You need to run `mfsmaster-init` on a freshly installed master server to
            initialize the `DATA_PATH` directory.
          '';
          default = false;
        };

        exports = mkOption {
          type = with types; listOf str;
          default = null;
          description = lib.mdDoc "Paths to export (see mfsexports.cfg).";
          example = [
            "* / rw,alldirs,admin,maproot=0:0"
            "* . rw"
          ];
        };

        openFirewall = mkOption {
          type = types.bool;
          description = lib.mdDoc "Whether to automatically open the necessary ports in the firewall.";
          default = false;
        };

        settings = mkOption {
          type = types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = mkOption {
              type = types.str;
              default = "/var/lib/mfs";
              description = lib.mdDoc "Data storage directory.";
            };
          };

          description = lib.mdDoc "Contents of config file (mfsmaster.cfg).";
        };
      };

      metalogger = {
        enable = mkEnableOption (lib.mdDoc "Moosefs metalogger daemon.");

        settings = mkOption {
          type = types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = mkOption {
              type = types.str;
              default = "/var/lib/mfs";
              description = lib.mdDoc "Data storage directory";
            };
          };

          description = lib.mdDoc "Contents of metalogger config file (mfsmetalogger.cfg).";
        };
      };

      chunkserver = {
        enable = mkEnableOption (lib.mdDoc "Moosefs chunkserver daemon.");

        openFirewall = mkOption {
          type = types.bool;
          description = lib.mdDoc "Whether to automatically open the necessary ports in the firewall.";
          default = false;
        };

        hdds = mkOption {
          type = with types; listOf str;
          default =  null;
          description = lib.mdDoc "Mount points to be used by chunkserver for storage (see mfshdd.cfg).";
          example = [ "/mnt/hdd1" ];
        };

        settings = mkOption {
          type = types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = mkOption {
              type = types.str;
              default = "/var/lib/mfs";
              description = lib.mdDoc "Directory for lock file.";
            };
          };

          description = lib.mdDoc "Contents of chunkserver config file (mfschunkserver.cfg).";
        };
      };
    };
  };

  ###### implementation

  config =  mkIf ( cfg.client.enable || cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable ) {

    warnings = [ ( mkIf (!cfg.runAsUser) "Running moosefs services as root is not recommended.") ];

    # Service settings
    services.moosefs = {
      master.settings = mkIf cfg.master.enable {
        WORKING_USER = mfsUser;
        EXPORTS_FILENAME = toString ( pkgs.writeText "mfsexports.cfg"
          (concatStringsSep "\n" cfg.master.exports));
      };

      metalogger.settings = mkIf cfg.metalogger.enable {
        WORKING_USER = mfsUser;
        MASTER_HOST = cfg.masterHost;
      };

      chunkserver.settings = mkIf cfg.chunkserver.enable {
        WORKING_USER = mfsUser;
        MASTER_HOST = cfg.masterHost;
        HDD_CONF_FILENAME = toString ( pkgs.writeText "mfshdd.cfg"
          (concatStringsSep "\n" cfg.chunkserver.hdds));
      };
    };

    # Create system user account for daemons
    users = mkIf ( cfg.runAsUser && ( cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable ) ) {
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
         optional cfg.master.enable "d ${cfg.master.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}"
      ++ optional cfg.metalogger.enable "d ${cfg.metalogger.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}"
      ++ optional cfg.chunkserver.enable "d ${cfg.chunkserver.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser}";

    # Service definitions
    systemd.services.mfs-master = mkIf cfg.master.enable
    ( systemdService "master" {
      TimeoutStartSec = 1800;
      TimeoutStopSec = 1800;
      Restart = "no";
    } masterCfg );

    systemd.services.mfs-metalogger = mkIf cfg.metalogger.enable
      ( systemdService "metalogger" { Restart = "on-abnormal"; } metaloggerCfg );

    systemd.services.mfs-chunkserver = mkIf cfg.chunkserver.enable
      ( systemdService "chunkserver" { Restart = "on-abnormal"; } chunkserverCfg );
    };
}
