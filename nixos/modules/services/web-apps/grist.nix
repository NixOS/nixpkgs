{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types
    ;

  cfg = config.services.grist;
in
{
  options.services.grist = {
    enable = mkEnableOption "Grist";

    package = mkPackageOption pkgs "grist-core" { };

    enableEnterprise = mkEnableOption "Grist enterprise code";

    enableRedis = mkEnableOption "Grist redis data store";

    environment = mkOption {
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

          GRIST_HOST = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = ''
              Address to listen on
            '';
          };

          GVISOR_FLAGS = mkOption {
            type = types.listOf types.str;
            default = [
              "-rootless"
            ];
            apply = concatStringsSep " ";
            description = ''
              The flags that are passed on to gVisor when creating a sandbox.
            '';
          };

          GRIST_SANDBOX_FLAVOR = mkOption {
            type = types.nullOr types.str;
            default = "gvisor";
            description = ''
              Sandbox to use for grist documents. Only "gvisor" is supported.
            '';
          };

          GVISOR_AVAILABLE = mkOption {
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
          GRIST_BOOT_KEY = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Grist password for first time configuration of your instance. You must remove it when your instance is configured.

              If null, this will be unset.
            '';
          };
          GRIST_DEFAULT_EMAIL = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              The user who logs in with the email defined by
              GRIST_DEFAULT_EMAIL is the administrator of this Grist
              installation. When Grist runs for the first time, it will create
              an account set to the value of GRIST_DEFAULT_EMAIL.

              If null, this will be unset.
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

        See [](https://github.com/gristlabs/grist-core/#environment-variables)
        for available environment variables.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Environment files for secrets.

        You must at least set GRIST_SESSION_KEY there.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environment.GRIST_SANDBOX_FLAVOR == "gvisor";
        message = "The current Grist module only supports gVisor sandboxing";
      }
    ];

    warnings =
      optional (cfg.environment.GRIST_BOOT_KEY != null)
        "GRIST_BOOT_KEY is world-readable in the Nix Store, you should remove it when your instance is configured or set it in the environment file as a secret.";

    services.grist = {
      package = mkDefault (pkgs.grist-core.override { enterpriseEdition = cfg.enableEnterprise; });
      environment = {
        REDIS_URL = mkIf cfg.enableRedis "redis://localhost:${builtins.toString config.services.redis.servers.grist.port}";
        NODE_PATH = concatMapStringsSep ":" (v: "${cfg.package}/grist-core/${v}") [
          "_build"
          "_build/ext"
          "_build/stubs"
          "ext/node_modules"
        ];
      };
    };

    systemd.services.grist-core = {
      description = "Grist Core";

      after = [
        "network.target"
      ]
      ++ optional (cfg.environment.TYPEORM_TYPE == "postgres") "postgresql.service";

      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.nodejs
        cfg.package.pythonEnv
        pkgs.gvisor
        pkgs.procps
        pkgs.glibc.bin
      ];

      inherit (cfg) environment;

      serviceConfig = {
        ExecStart = "${pkgs.nodejs}/bin/node ${cfg.package}/grist-core/_build/stubs/app/server/server.js";

        DynamicUser = true;
        Restart = "always";

        StateDirectory = "grist-core";
        WorkingDirectory = "/var/lib/grist-core";

        Delegate = "yes";

        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        LockPersonality = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;

        EnvironmentFile = cfg.environmentFiles;
      };
    };
    services.redis.servers = mkIf cfg.enableRedis {
      "grist" = {
        enable = true;
        port = 6380;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ sinavir ];
}
