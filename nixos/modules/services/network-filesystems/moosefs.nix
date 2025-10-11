{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.moosefs;

  mfsUser = if cfg.runAsUser then "moosefs" else "root";

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
        with lib.types;
        let
          valueType =
            oneOf (
              [
                (listOf valueType)
              ]
              ++ allowedTypes
            )
            // {
              description = "Flat key-value file";
            };
        in
        attrsOf valueType;

      generate =
        name: value:
        pkgs.writeText name (
          lib.concatStringsSep "\n" (lib.mapAttrsToList (key: val: "${key} = ${valueToString val}") value)
        );
    };

  # Manual initialization tool
  initTool = pkgs.writeShellScriptBin "mfsmaster-init" ''
    if [ ! -e ${cfg.master.settings.DATA_PATH}/metadata.mfs ]; then
      cp ${pkgs.moosefs}/var/mfs/metadata.mfs.empty ${cfg.master.settings.DATA_PATH}
      chmod +w ${cfg.master.settings.DATA_PATH}/metadata.mfs.empty
      ${pkgs.moosefs}/bin/mfsmaster -a -c ${masterCfg} start
      ${pkgs.moosefs}/bin/mfsmaster -c ${masterCfg} stop
      rm ${cfg.master.settings.DATA_PATH}/metadata.mfs.empty
    fi
  '';

  masterCfg = settingsFormat.generate "mfsmaster.cfg" cfg.master.settings;
  metaloggerCfg = settingsFormat.generate "mfsmetalogger.cfg" cfg.metalogger.settings;
  chunkserverCfg = settingsFormat.generate "mfschunkserver.cfg" cfg.chunkserver.settings;

  systemdService = name: extraConfig: configFile: {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network.target"
      "network-online.target"
    ];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} start";
      ExecStop = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} stop";
      ExecReload = "${pkgs.moosefs}/bin/mfs${name} -c ${configFile} reload";
      PIDFile = "${cfg."${name}".settings.DATA_PATH}/.mfs${name}.lock";
    }
    // extraConfig;
  };

in
{
  ###### interface
  options = {
    services.moosefs = {
      masterHost = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "IP or DNS name of the MooseFS master server.";
      };

      runAsUser = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Run daemons as moosefs user instead of root for better security.";
      };

      client.enable = lib.mkEnableOption "MooseFS client";

      master = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Enable MooseFS master daemon.
            The master server coordinates all MooseFS operations and stores metadata.
          '';
          default = false;
        };

        autoInit = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to automatically initialize the master's metadata directory on first run. Use with caution.";
        };

        exports = lib.mkOption {
          type = with lib.types; listOf str;
          default = null;
          description = "Export definitions for MooseFS (see mfsexports.cfg).";
          example = [
            "* / rw,alldirs,admin,maproot=0:0"
            "* . rw"
          ];
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open required firewall ports for master service.";
          default = false;
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/mfs";
              description = "Directory for storing master metadata.";
            };
          };
          description = "Master configuration options (mfsmaster.cfg).";
        };
      };

      metalogger = {
        enable = lib.mkEnableOption "MooseFS metalogger daemon that maintains a backup copy of the master's metadata";

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/mfs";
              description = "Directory for storing metalogger data.";
            };
          };
          description = "Metalogger configuration options (mfsmetalogger.cfg).";
        };
      };

      chunkserver = {
        enable = lib.mkEnableOption "MooseFS chunkserver daemon that stores file data";

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open required firewall ports for chunkserver service.";
          default = false;
        };

        hdds = lib.mkOption {
          type = with lib.types; listOf path;
          default = null;
          description = "Mount points used by chunkserver for data storage (see mfshdd.cfg).";
          example = [
            "/mnt/hdd1"
            "/mnt/hdd2"
          ];
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.DATA_PATH = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/mfs";
              description = "Directory for lock files and other runtime data.";
            };
          };
          description = "Chunkserver configuration options (mfschunkserver.cfg).";
        };
      };

      cgiserver = {
        enable = lib.mkEnableOption ''
          MooseFS CGI server for web interface.
          Warning: The CGI server interface should be properly secured from unauthorized access,
          as it provides full control over your MooseFS installation.
        '';

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to automatically open the web interface port.";
          default = false;
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
            options = {
              BIND_HOST = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                description = "IP address to bind CGI server to.";
              };

              PORT = lib.mkOption {
                type = lib.types.port;
                default = 9425;
                description = "Port for CGI server to listen on.";
              };
            };
          };
          default = { };
          description = "CGI server configuration options.";
        };
      };
    };
  };

  ###### implementation
  config =
    lib.mkIf
      (
        cfg.client.enable
        || cfg.master.enable
        || cfg.metalogger.enable
        || cfg.chunkserver.enable
        || cfg.cgiserver.enable
      )
      {
        warnings = [ (lib.mkIf (!cfg.runAsUser) "Running MooseFS services as root is not recommended.") ];

        services.moosefs = {
          master.settings = lib.mkIf cfg.master.enable (
            lib.mkMerge [
              {
                WORKING_USER = mfsUser;
                EXPORTS_FILENAME = toString (
                  pkgs.writeText "mfsexports.cfg" (lib.concatStringsSep "\n" cfg.master.exports)
                );
              }
              (lib.mkIf cfg.cgiserver.enable {
                MFSCGISERV = toString cfg.cgiserver.settings.PORT;
              })
            ]
          );

          metalogger.settings = lib.mkIf cfg.metalogger.enable {
            WORKING_USER = mfsUser;
            MASTER_HOST = cfg.masterHost;
          };

          chunkserver.settings = lib.mkIf cfg.chunkserver.enable {
            WORKING_USER = mfsUser;
            MASTER_HOST = cfg.masterHost;
            HDD_CONF_FILENAME = toString (
              pkgs.writeText "mfshdd.cfg" (lib.concatStringsSep "\n" cfg.chunkserver.hdds)
            );
          };
        };

        users =
          lib.mkIf
            (
              cfg.runAsUser
              && (cfg.master.enable || cfg.metalogger.enable || cfg.chunkserver.enable || cfg.cgiserver.enable)
            )
            {
              users.moosefs = {
                isSystemUser = true;
                description = "MooseFS daemon user";
                group = "moosefs";
              };
              groups.moosefs = { };
            };

        environment.systemPackages =
          (lib.optional cfg.client.enable pkgs.moosefs) ++ (lib.optional cfg.master.enable initTool);

        networking.firewall.allowedTCPPorts = lib.mkMerge [
          (lib.optionals cfg.master.openFirewall [
            9419
            9420
            9421
          ])
          (lib.optional cfg.chunkserver.openFirewall 9422)
          (lib.optional (cfg.cgiserver.enable && cfg.cgiserver.openFirewall) cfg.cgiserver.settings.PORT)
        ];

        systemd.tmpfiles.rules = [
          # Master directories
          (lib.optionalString cfg.master.enable "d ${cfg.master.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser} -")

          # Metalogger directories
          (lib.optionalString cfg.metalogger.enable "d ${cfg.metalogger.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser} -")

          # Chunkserver directories
          (lib.optionalString cfg.chunkserver.enable "d ${cfg.chunkserver.settings.DATA_PATH} 0700 ${mfsUser} ${mfsUser} -")
        ]
        ++ lib.optionals (cfg.chunkserver.enable && cfg.chunkserver.hdds != null) (
          map (dir: "d ${dir} 0755 ${mfsUser} ${mfsUser} -") cfg.chunkserver.hdds
        );

        systemd.services = lib.mkMerge [
          (lib.mkIf cfg.master.enable {
            mfs-master = (
              lib.mkMerge [
                (systemdService "master" {
                  TimeoutStartSec = 1800;
                  TimeoutStopSec = 1800;
                  Restart = "on-failure";
                  User = mfsUser;
                } masterCfg)
                {
                  preStart = lib.mkIf cfg.master.autoInit "${initTool}/bin/mfsmaster-init";
                }
              ]
            );
          })

          (lib.mkIf cfg.metalogger.enable {
            mfs-metalogger = systemdService "metalogger" {
              Restart = "on-abnormal";
              User = mfsUser;
            } metaloggerCfg;
          })

          (lib.mkIf cfg.chunkserver.enable {
            mfs-chunkserver = systemdService "chunkserver" {
              Restart = "on-abnormal";
              User = mfsUser;
            } chunkserverCfg;
          })

          (lib.mkIf cfg.cgiserver.enable {
            mfs-cgiserv = {
              description = "MooseFS CGI Server";
              wantedBy = [ "multi-user.target" ];
              after = [ "mfs-master.service" ];

              serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.moosefs}/bin/mfscgiserv -D /var/lib/mfs -f start";
                ExecStop = "${pkgs.moosefs}/bin/mfscgiserv -D /var/lib/mfs stop";
                Restart = "on-failure";
                RestartSec = "30s";
                User = mfsUser;
                Group = mfsUser;
                WorkingDirectory = "/var/lib/mfs";
              };
            };
          })
        ];
      };
}
