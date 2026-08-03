{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    optional
    optionalAttrs
    ;

  cfg = config.services.scholarsome;

  redisDefaultPort = 6379;
in
{
  options.services.scholarsome = {
    enable = mkEnableOption "Scholarsome, a web-based interactive flashcard learning software";

    package = mkPackageOption pkgs "scholarsome" { };

    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "Domain Scholarsome will be running on. Do not include `http(s)://`.";
    };

    port = mkOption {
      type = types.port;
      default = 9090;
      description = "Port number Scholarsome will be listening on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the Scholarsome port in the firewall.";
    };

    storageType = mkOption {
      type = types.enum [
        "local"
        "s3"
      ];
      default = "local";
      description = ''
        Type of storage used by Scholarsome to store media files (i.e. flashcard attachments).
        If `"local"`, media files will be stored under `/var/lib/scholarsome`.
      '';
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically create a local MariaDB instance.

          When bringing your own, don't forget to set `DATABASE_URL` in your {option}`environmentFile`.
          The format is as follows: `mysql://(username):(password)@(host):(port)/(database)`.
        '';
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to automatically create a local Redis instance, with authentication disabled.

          You can bring your own authenticated instance using the `REDIS_*` variables in {option}`environmentFile`.
        '';
      };

      port = mkOption {
        type = types.port;
        default = redisDefaultPort;
        description = "Port used by the Redis instance.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/scholarsome-redis-password";
        description = ''
          Path to the file containing the password to set and use for the locally created Redis instance.
          Leave it unset if you don't want to use one.
        '';
      };
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/scholarsome.env";
      description = ''
        Path to an environment file loaded by Scholarsome.
        May be used for secrets that should not be included in the Nix store (e.g. `JWT_SECRET`, `SMTP_PASSWORD`, ...).
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        SMTP_HOST = "localhost";
        SMTP_PORT = "25";
      };
      description = ''
        Additional environment variables passed to Scholarsome.

        See the [documentation](https://web.archive.org/web/20260531111936if_/https://scholarsome.com/handbook/installation/installing/#:~:text=Docker%20Environment%20Variables) for the full list of supported variables.
        Prefer {option}`environmentFile` for secrets, to avoid storing them in the Nix store.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environmentFile != null || cfg.settings != { };
        message = ''
          Scholarsome requires `JWT_SECRET` to be set.

          You may use either of:
            - `services.scholarsome.environmentFile`
              (prefer this one to avoid writing secrets to the Nix store)
            - `services.scholarsome.settings`
        '';
      }
      {
        assertion = !cfg.redis.createLocally -> cfg.redis.port == redisDefaultPort;
        message = "When `createLocally` is disabled, please specify the port to your own Redis instance using `services.scholarsome.settings.REDIS_PORT` or `services.scholarsome.environmentFile` instead of `services.scholarsome.redis.port`.";
      }
      {
        assertion = !cfg.redis.createLocally -> cfg.redis.passwordFile == null;
        message = "When `createLocally` is disabled, please specify the password to your own Redis instance using `REDIS_PASSWORD` in `services.scholarsome.environmentFile`, instead of `services.scholarsome.redis.passwordFile`.";
      }
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "scholarsome" ];
      ensureUsers = [
        {
          name = "scholarsome";
          ensurePermissions = {
            "scholarsome.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.redis.servers.scholarsome = mkIf cfg.redis.createLocally {
      enable = true;
      bind = "127.0.0.1";
      port = cfg.redis.port;
      save = [
        [
          900
          1
        ]
      ];
      appendOnly = true;
      settings.appendfilename = "appendonly.aof";
      requirePassFile = cfg.redis.passwordFile;
    };

    # This redis instance is only used by Scholarsome.
    # So we can safely propagate stop and restart actions from the Scholarsome service to redis.
    systemd.services.redis-scholarsome = mkIf cfg.redis.createLocally {
      partOf = [ "scholarsome.service" ];
    };

    systemd.services.scholarsome = {
      description = "Scholarsome";

      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ optional cfg.database.createLocally "mysql.service"
      ++ optional cfg.redis.createLocally "redis-scholarsome.service";
      requires =
        optional cfg.database.createLocally "mysql.service"
        ++ optional cfg.redis.createLocally "redis-scholarsome.service";

      path = [
        # npm needs bash available during prisma migration
        pkgs.bash
      ];

      environment = {
        HOST = cfg.host;
        HTTP_PORT = toString cfg.port;
        STORAGE_TYPE = cfg.storageType;
        NODE_ENV = "production";
      }
      // optionalAttrs cfg.database.createLocally {
        DATABASE_URL = "mysql://scholarsome@localhost/scholarsome?socket=/run/mysqld/mysqld.sock";
      }
      // optionalAttrs cfg.redis.createLocally {
        REDIS_HOST = config.services.redis.servers.scholarsome.bind;
        REDIS_PORT = toString cfg.redis.port;
      }
      // optionalAttrs (cfg.storageType == "local") {
        STORAGE_LOCAL_DIR = "/var/lib/scholarsome";
      }
      # Note : placed at the end, it enables the user to override all of the above, so things may break.
      // cfg.settings;

      preStart = ''
        echo "Applying Prisma migrations..."
        ${lib.getExe' cfg.package "scholarsome-migrate"}
      '';

      script = ''
        ${lib.optionalString (cfg.redis.passwordFile != null) ''
          export REDIS_PASSWORD="$(cat $CREDENTIALS_DIRECTORY/redis-password)"
        ''}
        ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = optional (
          cfg.redis.passwordFile != null
        ) "redis-password:${cfg.redis.passwordFile}";
        DynamicUser = true;
        StateDirectory = "scholarsome";
        Restart = "on-failure";
        RestartSec = "30s";
        # Default Node.js response to SIGTERM
        SuccessExitStatus = [ 143 ];
        # --- Hardening ---
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        LockPersonality = true;
        PrivateMounts = true;
        ProtectKernelLogs = true;
        RemoveIPC = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        # Node needs this for JIT
        MemoryDenyWriteExecute = false;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ vitto4 ];
}
