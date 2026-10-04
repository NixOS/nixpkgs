{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.buzz-relay;
in
{
  options.services.buzz-relay = {
    enable = lib.mkEnableOption "Buzz Nostr relay and workspace server daemon";

    package = lib.mkPackageOption pkgs "buzz-relay" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address to listen on for WebSocket and HTTP API connections.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port to listen on for WebSocket and HTTP API connections.";
    };

    relayUrl = lib.mkOption {
      type = lib.types.str;
      example = "wss://buzz.example.com";
      description = ''
        Public WebSocket URL of the relay. Used in NIP-42 authentication
        challenges and community discovery.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/buzz-relay";
      description = "Data directory for buzz-relay state and local git repositories.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/buzz.env";
      description = ''
        Environment file containing secrets for buzz-relay:
        - `BUZZ_RELAY_PRIVATE_KEY`: 32-byte hex Nostr private key.
        - `BUZZ_S3_ACCESS_KEY`: S3 access key ID for object storage.
        - `BUZZ_S3_SECRET_KEY`: S3 secret access key.
        - `TYPESENSE_API_KEY`: API key for Typesense search (optional).
      '';
    };

    autoMigrate = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically run database schema migrations on service startup.";
    };

    gitConformanceProbe = lib.mkOption {
      type = lib.types.bool;
      default = cfg.s3.endpoint != null;
      defaultText = lib.literalExpression "config.services.buzz-relay.s3.endpoint != null";
      description = "Whether to run the Git object-store linearizable write conformance probe on startup. Requires an S3 backend.";
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to automatically configure a local PostgreSQL database and user for buzz-relay.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "buzz-relay";
        description = "Database name to connect to and create if createLocally is true.";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "postgresql://buzz:password@127.0.0.1:5432/buzz";
        description = ''
          PostgreSQL connection URL. If null and `createLocally` is true,
          buzz-relay connects via local Unix domain socket.
        '';
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to automatically configure a local Redis instance for buzz-relay.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "redis://127.0.0.1:6379";
        description = "Redis connection URL.";
      };
    };

    typesense = {
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "http://127.0.0.1:8108";
        description = "Typesense URL for full-text message search indexing.";
      };
    };

    s3 = {
      endpoint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "http://127.0.0.1:9000";
        description = "S3-compatible object storage endpoint URL (Garage, MinIO, or AWS S3).";
      };

      bucket = lib.mkOption {
        type = lib.types.str;
        default = "buzz-media";
        description = "S3 bucket name for media and repository storage.";
      };

      region = lib.mkOption {
        type = lib.types.str;
        default = "us-east-1";
        description = "S3 region.";
      };

      addressingStyle = lib.mkOption {
        type = lib.types.enum [
          "path"
          "virtual"
        ];
        default = "path";
        description = "S3 addressing style ('path' for Garage/MinIO, 'virtual' for AWS S3).";
      };
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the relay port in the firewall.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra environment variables passed to the buzz-relay service.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "buzz-relay";
      description = "User account under which buzz-relay runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "buzz-relay";
      description = "Group account under which buzz-relay runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      description = "Buzz Relay service user";
      home = cfg.dataDir;
    };

    users.groups.${cfg.group} = { };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = cfg.database.name == cfg.user;
        }
      ];
    };

    services.redis.servers = lib.mkIf cfg.redis.createLocally {
      "buzz-relay" = {
        enable = true;
        port = 6379;
      };
    };

    systemd.services.buzz-relay = {
      description = "Buzz Nostr relay server";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.service"
      ++ lib.optional cfg.redis.createLocally "redis-buzz-relay.service";
      after = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.service"
      ++ lib.optional cfg.redis.createLocally "redis-buzz-relay.service";

      environment = {
        BUZZ_BIND_ADDR = "${cfg.listenAddress}:${toString cfg.port}";
        RELAY_URL = cfg.relayUrl;
        BUZZ_GIT_REPO_PATH = "${cfg.dataDir}/repos";
        BUZZ_AUTO_MIGRATE = if cfg.autoMigrate then "true" else "false";
        BUZZ_GIT_CONFORMANCE_PROBE = if cfg.gitConformanceProbe then "true" else "false";
        REDIS_URL = cfg.redis.url;
        BUZZ_BASH_PATH = "${lib.getExe pkgs.bash}";
      }
      // lib.optionalAttrs (cfg.database.url != null) {
        DATABASE_URL = cfg.database.url;
      }
      // lib.optionalAttrs (cfg.database.url == null && cfg.database.createLocally) {
        DATABASE_URL = "postgresql://${cfg.user}@localhost/${cfg.database.name}?host=/run/postgresql";
      }
      // lib.optionalAttrs (cfg.typesense.url != null) {
        TYPESENSE_URL = cfg.typesense.url;
      }
      // lib.optionalAttrs (cfg.s3.endpoint != null) {
        BUZZ_S3_ENDPOINT = cfg.s3.endpoint;
        BUZZ_S3_BUCKET = cfg.s3.bucket;
        BUZZ_S3_REGION = cfg.s3.region;
        BUZZ_S3_ADDRESSING_STYLE = cfg.s3.addressingStyle;
      }
      // cfg.extraEnvironment;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/buzz-relay";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "buzz-relay";
        StateDirectoryMode = "0750";
        Restart = "always";
        RestartSec = 5;

        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ kleinbem ];
}
