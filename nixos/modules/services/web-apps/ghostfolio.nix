{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ghostfolio;

  environmentValue =
    value:
    if lib.isList value then
      builtins.toJSON value
    else if lib.isBool value then
      lib.boolToString value
    else
      toString value;
in
{
  options.services.ghostfolio = {
    enable = lib.mkEnableOption "Ghostfolio";

    package = lib.mkPackageOption pkgs "ghostfolio" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the Ghostfolio port in the firewall.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
            (listOf str)
          ]);

        options = {
          HOST = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Address on which Ghostfolio listens.";
          };

          PORT = lib.mkOption {
            type = lib.types.port;
            default = 3333;
            description = "Port on which Ghostfolio listens.";
          };

          ROOT_URL = lib.mkOption {
            type = lib.types.str;
            default = "http://localhost:${toString cfg.settings.PORT}";
            defaultText = lib.literalExpression ''"http://localhost:''${toString config.services.ghostfolio.settings.PORT}"'';
            description = ''
              The public URL of the Ghostfolio instance.
              Set this explicitly when deploying behind a reverse proxy.
            '';
          };

          DATABASE_URL = lib.mkOption {
            type = lib.types.str;
            default = "postgresql://ghostfolio@localhost/ghostfolio?host=/run/postgresql";
            description = "The database connection URL.";
          };

          REDIS_HOST = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Redis server address.";
          };

          REDIS_PORT = lib.mkOption {
            type = lib.types.port;
            default = 6379;
            description = "Redis server port.";
          };
        };
      };
      default = { };
      example = {
        ROOT_URL = "https://ghostfolio.example.com";
        ENABLE_FEATURE_AUTH_TOKEN = true;
      };
      description = ''
        Ghostfolio configuration as environment variables.

        See <https://github.com/ghostfolio/ghostfolio#self-hosting> for the
        available options. Sensitive values should be supplied with
        {option}`services.ghostfolio.environmentFiles` instead.

        Set `ROOT_URL` explicitly when deploying behind a reverse proxy.
      '';
    };

    environmentFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      example = [ "/run/secrets/ghostfolio.env" ];
      description = ''
        Environment files passed to Ghostfolio. This is the recommended way
        to provide secrets such as `JWT_SECRET_KEY` and `ACCESS_TOKEN_SALT` as the file is not added to the Nix store.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable and configure a local PostgreSQL database.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable and configure a local Redis server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.PORT ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "ghostfolio" ];
      ensureUsers = [
        {
          name = "ghostfolio";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.ghostfolio = lib.mkIf cfg.redis.createLocally {
      enable = true;
      bind = "localhost";
      port = cfg.settings.REDIS_PORT;
    };

    systemd.services.ghostfolio = {
      description = "Ghostfolio wealth management software";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional cfg.redis.createLocally "redis-ghostfolio.service";
      requires =
        lib.optional cfg.database.createLocally "postgresql.target"
        ++ lib.optional cfg.redis.createLocally "redis-ghostfolio.service";

      environment = lib.mapAttrs (_: environmentValue) cfg.settings;

      serviceConfig = {
        ExecStartPre = lib.getExe' cfg.package "ghostfolio-migrate";
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = cfg.environmentFiles;
        DynamicUser = true;
        PrivateTmp = true;
        Restart = "always";
        UMask = "0077";

        # Hardening
        MemoryDenyWriteExecute = false; # Required by V8 JIT
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
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
          "@pkey"
        ];
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ DeltaCalcium ];
  };
}
