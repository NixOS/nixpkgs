{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    types
    mkOption
    mkPackageOption
    mkEnableOption
    mkIf
    ;

  cfg = config.services.grist-core;
in
{
  meta.maintainers = with lib.maintainers; [ scandiravian ];

  options.services.grist-core = {
    enable = mkEnableOption "Grist core";

    package = mkPackageOption pkgs "grist-core" { };

    user = mkOption {
      type = types.str;
      default = "grist-core";
      description = "User account under which grist-core runs.";
    };

    group = mkOption {
      type = types.str;
      default = "grist-core";
      description = "Group under which grist-core runs.";
    };

    pythonEnv = mkOption {
      internal = true;
      type = types.package;
      default = pkgs.grist-core.pythonEnv;
      example = literalExpression ''
        pkgs.python3.withPackages (ps: with ps; [
          astroid
          asttokens
          chardet
          et-xmlfile
          executing
          friendly-traceback
          iso8601
          lazy-object-proxy
          openpyxl
          phonenumbers
          pure-eval
          python-dateutil
          roman
          six
          sortedcontainers
          stack-data
          typing-extensions
          unittest-xml-reporting
          wrapt
        ]);
      '';
    };

    enableSandboxing = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Isolate untrusted documents in a sandbox.
      '';
    };

    settings = mkOption {
      type =
        with types;
        submodule {
          freeformType = attrsOf (oneOf [
            str
            null
          ]);

          options = {
            GRIST_DATA_DIR = mkOption {
              type = str;
              default = "/var/lib/grist-core/docs";
              description = ''
                Directory in which to store documents.
              '';
            };

            GRIST_INST_DIR = mkOption {
              type = str;
              default = "/var/lib/grist-core";
              description = ''
                Path to Grist instance configuration files, for Grist server.
              '';
            };

            GRIST_USER_ROOT = mkOption {
              type = str;
              default = "/var/lib/grist-core";
              description = ''
                An extra path to look for plugins in - Grist will scan for plugins in $GRIST_USER_ROOT/plugins.
              '';
            };

            GRIST_SANDBOX_FLAVOR = mkOption {
              type = nullOr str;
              default = if cfg.enableSandboxing then "gvisor" else null;
              readOnly = true;
              description = ''
                If set, forces Grist to use the specified kind of sandbox.
              '';
            };

            GVISOR_FLAGS = mkOption {
              type = str;
              default = "-rootless -debug";
              description = ''
                The flags that are passed on to gVisor when creating a sandbox.
              '';
            };

            GVISOR_AVAILABLE = mkOption {
              type = str;
              default = "1";
              readOnly = true;
              description = ''
                Whether gvisor is available for Grist.
              '';
            };

            TYPEORM_DATABASE = mkOption {
              type = str;
              default = "/var/lib/grist-core/db.sqlite";
              description = ''
                Database filename for sqlite or database name for other db types.
              '';
            };

            TYPEORM_TYPE = mkOption {
              type = enum [
                "sqlite"
                "postgres"
              ];
              default = "sqlite";
              description = ''
                Which database type to use for storage.
              '';
            };
          };
        };
      default = { };
      example = {
        GRIST_DEFAULT_EMAIL = "example@example.com";
      };
      description = ''
        Environment variables used for Grist.
        See [](https://github.com/gristlabs/grist-core/tree/v1.3.2?tab=readme-ov-file#environment-variables)
        for available environment variables.
      '';
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = ''
        Environment files for secrets.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.grist-core = {
      description = "Grist Core";

      after = [
        "network.target"
      ] ++ lib.optional (cfg.settings.TYPEORM_TYPE == "postgres") "postgresql.service";

      wants = [ "network.target" ];

      path = [
        pkgs.gvisor
        cfg.pythonEnv
      ];

      environment = cfg.settings;

      serviceConfig =
        {
          ExecStart = lib.getExe cfg.package;

          DynamicUser = true;
          User = cfg.user;
          Group = cfg.group;

          Restart = "always";

          RuntimeDirectory = "grist-core";
          StateDirectory = "grist-core";

          ProtectHome = true;
          ProtectSystem = "strict";
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          NoNewPrivileges = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;

          EnvironmentFile = cfg.environmentFiles;
        }
        // (lib.optionalAttrs cfg.enableSandboxing {
          RootDirectory = "/run/grist-core/";

          ReadWritePaths = "";

          TemporaryFileSystem = [
            "/usr:ro"
            "/usr/local/lib:ro"
          ];

          BindPaths = [
            cfg.settings.GRIST_INST_DIR
            cfg.settings.GRIST_DATA_DIR
          ];

          BindReadOnlyPaths = [
            builtins.storeDir
            "/etc"
            "${cfg.pythonEnv}/bin:/usr/bin"
            "${cfg.pythonEnv}/lib:/usr/lib"
          ];
        });

      wantedBy = [ "multi-user.target" ];
    };
  };
}
