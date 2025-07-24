{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.saunafs;

  settingsFormat =
    let
      listSep = " ";
      allowedTypes = with lib.types; [
        bool
        int
        float
        str
      ];
      valueToString =
        val:
        if lib.isList val then
          lib.concatStringsSep listSep (map (x: valueToString x) val)
        else if lib.isBool val then
          (if val then "1" else "0")
        else
          toString val;

    in
    {
      type =
        let
          valueType =
            lib.types.oneOf (
              [
                (lib.types.listOf valueType)
              ]
              ++ allowedTypes
            )
            // {
              description = "Flat key-value file";
            };
        in
        lib.types.attrsOf valueType;

      generate =
        name: value:
        pkgs.writeText name (
          lib.concatStringsSep "\n" (lib.mapAttrsToList (key: val: "${key} = ${valueToString val}") value)
        );
    };

  initTool = pkgs.writeShellScriptBin "sfsmaster-init" ''
    if [ ! -e ${cfg.master.settings.DATA_PATH}/metadata.sfs ]; then
      cp --update=none ${pkgs.saunafs}/var/lib/saunafs/metadata.sfs.empty ${cfg.master.settings.DATA_PATH}/metadata.sfs
      chmod +w ${cfg.master.settings.DATA_PATH}/metadata.sfs
    fi
  '';

  # master config file
  masterCfg = settingsFormat.generate "sfsmaster.cfg" cfg.master.settings;

  # metalogger config file
  metaloggerCfg = settingsFormat.generate "sfsmetalogger.cfg" cfg.metalogger.settings;

  # chunkserver config file
  chunkserverCfg = settingsFormat.generate "sfschunkserver.cfg" cfg.chunkserver.settings;

  # generic template for all daemons
  systemdService = name: extraConfig: configFile: {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network.target"
      "network-online.target"
    ];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.saunafs}/bin/sfs${name} -c ${configFile} start";
      ExecStop = "${pkgs.saunafs}/bin/sfs${name} -c ${configFile} stop";
      ExecReload = "${pkgs.saunafs}/bin/sfs${name} -c ${configFile} reload";
    }
    // extraConfig;
  };

in
{
  ###### interface

  options = {
    services.saunafs = {
      masterHost = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "IP or hostname name of master host.";
      };

      sfsUser = lib.mkOption {
        type = lib.types.str;
        default = "saunafs";
        description = "Run daemons as user.";
      };

      client.enable = lib.mkEnableOption "Saunafs client";

      master = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Enable Saunafs master daemon.

            You need to run `sfsmaster-init` on a freshly installed master server to
            initialize the `DATA_PATH` directory.
          '';
          default = false;
        };

        exports = lib.mkOption {
          type = with lib.types; listOf str;
          default = null;
          description = "Paths to exports file (see {manpage}`sfsexports.cfg(5)`).";
          example = lib.literalExpression ''
            [ "* / rw,alldirs,admin,maproot=0:0" ];
          '';
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
              default = "/var/lib/saunafs/master";
              description = "Data storage directory.";
            };
          };

          description = "Contents of config file ({manpage}`sfsmaster.cfg(5)`).";
        };
      };

      metalogger = {
        enable = lib.mkEnableOption "Saunafs metalogger daemon";

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/saunafs/metalogger";
              description = "Data storage directory";
            };
          };

          description = "Contents of metalogger config file (see {manpage}`sfsmetalogger.cfg(5)`).";
        };
      };

      chunkserver = {
        enable = lib.mkEnableOption "Saunafs chunkserver daemon";

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open the necessary ports in the firewall.";
          default = false;
        };

        hdds = lib.mkOption {
          type = with lib.types; listOf str;
          default = null;

          example = lib.literalExpression ''
            [ "/mnt/hdd1" ];
          '';

          description = ''
            Mount points to be used by chunkserver for storage (see {manpage}`sfshdd.cfg(5)`).

            Note, that these mount points must writeable by the user defined by the saunafs user.
          '';
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/saunafs/chunkserver";
              description = "Directory for chunck meta data";
            };
          };

          description = "Contents of chunkserver config file (see {manpage}`sfschunkserver.cfg(5)`).";
        };
      };
    };
  };

  ###### implementation

  config =
    lib.mkIf (cfg.client.enable || cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable)
      {

        warnings = [
          (lib.mkIf (cfg.sfsUser == "root") "Running saunafs services as root is not recommended.")
        ];

        # Service settings
        services.saunafs = {
          master.settings = lib.mkIf cfg.master.enable {
            WORKING_USER = cfg.sfsUser;
            EXPORTS_FILENAME = toString (
              pkgs.writeText "sfsexports.cfg" (lib.concatStringsSep "\n" cfg.master.exports)
            );
          };

          metalogger.settings = lib.mkIf cfg.metalogger.enable {
            WORKING_USER = cfg.sfsUser;
            MASTER_HOST = cfg.masterHost;
          };

          chunkserver.settings = lib.mkIf cfg.chunkserver.enable {
            WORKING_USER = cfg.sfsUser;
            MASTER_HOST = cfg.masterHost;
            HDD_CONF_FILENAME = toString (
              pkgs.writeText "sfshdd.cfg" (lib.concatStringsSep "\n" cfg.chunkserver.hdds)
            );
          };
        };

        # Create system user account for daemons
        users =
          lib.mkIf
            (cfg.sfsUser != "root" && (cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable))
            {
              users."${cfg.sfsUser}" = {
                isSystemUser = true;
                description = "saunafs daemon user";
                group = "saunafs";
              };
              groups."${cfg.sfsUser}" = { };
            };

        environment.systemPackages =
          (lib.optional cfg.client.enable pkgs.saunafs) ++ (lib.optional cfg.master.enable initTool);

        networking.firewall.allowedTCPPorts =
          (lib.optionals cfg.master.openFirewall [
            9419
            9420
            9421
          ])
          ++ (lib.optional cfg.chunkserver.openFirewall 9422);

        # Ensure storage directories exist
        systemd.tmpfiles.rules =
          lib.optional cfg.master.enable "d ${cfg.master.settings.DATA_PATH} 0700 ${cfg.sfsUser} ${cfg.sfsUser} -"
          ++ lib.optional cfg.metalogger.enable "d ${cfg.metalogger.settings.DATA_PATH} 0700 ${cfg.sfsUser} ${cfg.sfsUser} -"
          ++ lib.optional cfg.chunkserver.enable "d ${cfg.chunkserver.settings.DATA_PATH} 0700 ${cfg.sfsUser} ${cfg.sfsUser} -";

        # Service definitions
        systemd.services.sfs-master = lib.mkIf cfg.master.enable (
          systemdService "master" {
            TimeoutStartSec = 1800;
            TimeoutStopSec = 1800;
            Restart = "no";
          } masterCfg
        );

        systemd.services.sfs-metalogger = lib.mkIf cfg.metalogger.enable (
          systemdService "metalogger" { Restart = "on-abort"; } metaloggerCfg
        );

        systemd.services.sfs-chunkserver = lib.mkIf cfg.chunkserver.enable (
          systemdService "chunkserver" { Restart = "on-abort"; } chunkserverCfg
        );
      };
}
