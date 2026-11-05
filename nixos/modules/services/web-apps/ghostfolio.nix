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

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address on which Ghostfolio listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3333;
      description = "Port on which Ghostfolio listens.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the Ghostfolio port in the firewall.";
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          int
          str
          (listOf str)
        ]);
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
      '';
    };

    environmentFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      example = [ "/run/secrets/ghostfolio.env" ];
      description = ''
        Environment files passed to Ghostfolio. This is the recommended way
        to provide secrets such as `JWT_SECRET_KEY` and `ACCESS_TOKEN_SALT`.
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

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Redis server address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "Redis server port.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.redis.createLocally -> cfg.redis.host == "localhost";
        message = "services.ghostfolio.redis.host must be localhost when services.ghostfolio.redis.createLocally is enabled";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    services.ghostfolio.settings = {
      HOST = lib.mkDefault cfg.host;
      PORT = lib.mkDefault cfg.port;
      DATABASE_URL = lib.mkIf cfg.database.createLocally (
        lib.mkDefault "postgresql://ghostfolio@localhost/ghostfolio?host=/run/postgresql"
      );
      REDIS_HOST = lib.mkDefault cfg.redis.host;
      REDIS_PORT = lib.mkDefault cfg.redis.port;
    };

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
      port = cfg.redis.port;
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
          "AF_NETLINK"
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
