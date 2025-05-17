{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
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

    enableSandboxing = mkEnableOption "isolate untrusted documents in a sandbox";

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (types.nullOr types.str);

        options = {
          GRIST_DATA_DIR = mkOption {
            type = types.path;
            default = "/var/lib/grist-core/docs";
            description = ''
              Directory in which to store documents.
            '';
          };

          GRIST_INST_DIR = mkOption {
            type = types.path;
            default = "/var/lib/grist-core";
            description = ''
              Path to Grist instance configuration files, for Grist server.
            '';
          };

          GRIST_USER_ROOT = mkOption {
            type = types.path;
            default = "/var/lib/grist-core";
            description = ''
              An extra path to look for plugins in - Grist will scan for plugins in $GRIST_USER_ROOT/plugins.
            '';
          };

          GRIST_SANDBOX_FLAVOR = mkOption {
            type = types.nullOr types.str;
            default = if cfg.enableSandboxing then "gvisor" else null;
            defaultText = lib.literalExpression ''if cfg.enableSandboxing then "gvisor" else null'';
            description = ''
              Sandbox to use for grist documents. Only "gvisor" and no sandbox are supported.
            '';
          };

          GRIST_SANDBOX = mkOption {
            type = types.nullOr types.path;
            default = if !cfg.enableSandboxing then lib.getExe cfg.package.pythonEnv else null;
            defaultText = lib.literalExpression "if !cfg.enableSandboxing then lib.getExe cfg.package.pythonEnv else null";
            description = ''
              If set forces Grist to use the specified script for the sandbox. Or python if sandbox is disabled.
            '';
          };

          GVISOR_FLAGS = mkOption {
            type = types.listOf types.str;
            default = [
              "-rootless"
              "-debug"
            ];
            apply = lib.concatStringsSep " ";
            description = ''
              The flags that are passed on to gVisor when creating a sandbox.
            '';
          };

          GVISOR_AVAILABLE = mkOption {
            # TODO where is this set if it's read only?
            type = types.str;
            default = "1";
            readOnly = true;
            description = ''
              Whether gvisor is available for Grist.
            '';
          };

          TYPEORM_DATABASE = mkOption {
            type = types.str;
            default = "/var/lib/grist-core/db.sqlite";
            description = ''
              Database filename for sqlite or database name for other db types.
            '';
          };

          TYPEORM_TYPE = mkOption {
            type = types.enum [
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
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Environment files for secrets.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enableSandboxing -> cfg.settings.GRIST_SANDBOX_FLAVOR == "gvisor";
        message = "services.grist-core.enableSandboxing only supports gvisor";
      }
    ];

    systemd.services.grist-core = {
      description = "Grist Core";

      after = [
        "network.target"
      ] ++ lib.optional (cfg.settings.TYPEORM_TYPE == "postgres") "postgresql.service";

      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        cfg.package.pythonEnv
      ] ++ (lib.optional cfg.enableSandboxing pkgs.gvisor);

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
            "${cfg.package.pythonEnv}/bin:/usr/bin"
            "${cfg.package.pythonEnv}/lib:/usr/lib"
          ];
        });
    };
  };
}
