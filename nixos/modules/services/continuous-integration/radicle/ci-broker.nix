{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.radicle.ci.broker;

  settingsFormat = pkgs.formats.json { };
  configFile = pkgs.runCommand "ci-broker.json" { } (
    ''
      cp ${settingsFormat.generate "ci-broker.json" cfg.settings} $out
    ''
    + lib.optionalString cfg.checkConfig ''
      ${lib.getExe' cfg.package "cib"} --config $out config
    ''
  );

  RAD_HOME = "/var/lib/radicle";

  # Convenient wrapper to run `cibtool` in the namespaces of `radicle-ci-broker.service`
  cibtool-system = pkgs.writeShellScriptBin "cibtool-system" ''
    set -o allexport
    ${lib.toShellVars {
      inherit RAD_HOME;
      HOME = RAD_HOME;
    }}
    # Note that --env is not used to preserve host's envvars like $TERM
    exec ${lib.getExe' pkgs.util-linux "nsenter"} -a \
      -t "$(${lib.getExe' config.systemd.package "systemctl"} show -P MainPID radicle-ci-broker.service)" \
      -S "$(${lib.getExe' config.systemd.package "systemctl"} show -P UID radicle-ci-broker.service)" \
      -G "$(${lib.getExe' config.systemd.package "systemctl"} show -P GID radicle-ci-broker.service)" \
      ${lib.getExe' cfg.package "cibtool"} --db ${lib.escapeShellArg cfg.settings.db} "$@"
  '';
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.radicle.ci.broker = {
    enable = lib.mkEnableOption "radicle-ci-broker";

    package = lib.mkPackageOption pkgs "radicle-ci-broker" { };

    stateDir = lib.mkOption {
      type = lib.types.path;
      description = "State directory of radicle-ci-broker.";
      default = "/var/lib/radicle-ci";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      description = "Log directory of radicle-ci-broker.";
      default = "/var/log/radicle-ci";
    };

    enableHardening = lib.mkEnableOption "systemd hardening" // {
      default = true;
      example = false;
    };

    checkConfig =
      lib.mkEnableOption "checking the {file}`ci-broker.yaml` file resulting from [](#opt-services.radicle.ci.broker.settings)"
      // {
        default = true;
        example = false;
      };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          db = lib.mkOption {
            type = lib.types.path;
            description = "Database file path.";
            defaultText = lib.literalExpression ''"''${config.services.radicle.ci.broker.stateDir}/ci-broker.db"'';
          };

          report_dir = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            description = "Directory where HTML and JSON report pages are written.";
            defaultText = lib.literalExpression ''"''${config.services.radicle.ci.broker.stateDir}/reports"'';
          };

          adapters = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                freeformType = settingsFormat.type;

                options = {
                  command = lib.mkOption {
                    type = lib.types.str;
                    description = "Adapter command to run.";
                  };
                  env = lib.mkOption {
                    type = lib.types.attrsOf settingsFormat.type;
                    description = "Environment variables to add when running the adapter.";
                    default = { };
                  };
                };
              }
            );
            description = "CI adapters.";
            default = { };
          };

          triggers = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                freeformType = settingsFormat.type;

                options = {
                  adapter = lib.mkOption {
                    type = lib.types.str;
                    description = "Adapter name.";
                  };

                  filters = lib.mkOption {
                    type = lib.types.listOf settingsFormat.type;
                    description = "Trigger filter.";
                  };
                };
              }
            );
            description = "CI triggers.";
            default = [ ];
          };
        };
      };
      description = ''
        Configuration of radicle-ci-broker.
        See <https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8/tree/doc/userguide.md#configuration> for more information.
      '';
      default = { };
      example = lib.literalExpression ''
        {
          adapters.native = {
            command = lib.getExe pkgs.radicle-native-ci;
            config = { };
            config_env = "RADICLE_NATIVE_CI";
            env.PATH = lib.makeBinPath (with pkgs; [ bash coreutils ]);
          };

          triggers = [
            {
              adapter = "native";
              filters = [
                {
                  And = [
                    { HasFile = ".radicle/native.yaml"; }
                    { Node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; }
                    {
                      Or = [
                        "DefaultBranch"
                        "PatchCreated"
                        "PatchUpdated"
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.radicle.enable;
        message = "radicle-ci-broker requires a local radicle node to be running.";
      }
    ];

    services.radicle.ci.broker.settings = {
      db = lib.mkDefault "${cfg.stateDir}/ci-broker.db";
      report_dir = lib.mkDefault "${cfg.stateDir}/reports";
    };

    systemd.services.radicle-ci-broker = {
      wantedBy = [ "multi-user.target" ];

      bindsTo = [ "radicle-node.service" ];
      after = [ "radicle-node.service" ];

      environment = { inherit RAD_HOME; };

      serviceConfig = lib.mkMerge [
        {
          User = config.users.users.radicle.name;
          Group = config.users.groups.radicle.name;
          Restart = "always";

          StateDirectory = lib.mkIf (cfg.stateDir == "/var/lib/radicle-ci") "radicle-ci";
          LogsDirectory = lib.mkIf (cfg.logDir == "/var/log/radicle-ci") "radicle-ci";
          RuntimeDirectory = "radicle-ci-broker";
          WorkingDirectory = "/run/radicle-ci-broker";

          BindReadOnlyPaths = config.systemd.services.radicle-node.serviceConfig.BindReadOnlyPaths;
          ReadWritePaths = [ RAD_HOME ];

          ExecStart = "${lib.getExe' cfg.package "cib"} --config ${configFile} process-events";
        }

        (lib.mkIf cfg.enableHardening {
          AmbientCapabilities = "";
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          UMask = "0066";
        })
      ];
    };

    systemd.tmpfiles.settings.radicle-ci-broker.${cfg.settings.report_dir}.d = {
      user = config.users.users.radicle.name;
      group = config.users.groups.radicle.name;
    };

    environment.systemPackages = [ cibtool-system ];
  };
}
