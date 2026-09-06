# TODO: move to web-apps
{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    optionalAttrs
    optionals
    types
    ;
  cfg = config.services.fittrackee;
in
{
  options.services.fittrackee = {
    enable = mkEnableOption "Enable FitTrackee";
    email = {
      enable = mkEnableOption "Is email enabled? EMAIL_URL must be set";
      sender = mkOption {
        description = "The email address to send mail from";
        type = types.str;
      };
    };
    openFirewall = mkEnableOption "Open Firewall";
    user = mkOption {
      description = "User for FitTrackee";
      type = types.str;
      default = "fittrackee";
    };
    group = mkOption {
      description = "Group for FitTrackee";
      type = types.str;
      default = "fittrackee";
    };
    environmentFile = mkOption {
      description = "Path to the environment file. Override base settings in here.";
      type = types.either types.str types.path;
      default = "";
    };
    package = mkPackageOption pkgs "fittrackee" { };
    flaskPackage = mkPackageOption pkgs.python3Packages "flask" { };
    gunicornPackage = mkPackageOption pkgs.python3Packages "gunicorn" { };
    stateDir = mkOption {
      description = "Where to store the state and uploads";
      type = types.str;
      default = "/var/lib/fittrackee";
    };
    settings = mkOption {
      description = "Extra settings";
      type = types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          APP_WORKERS = mkOption {
            description = "How many Gunicorn Workers to use";
            type = types.int;
            default = 1;
          };
          DATABASE_URL = mkOption {
            description = "Database URL with username and password";
            type = types.str;
            default =
              if cfg.database.socket != null then
                "postgresql://${cfg.database.user}:@${cfg.database.name}?host=${cfg.database.socket}"
              else
                "postgresql://${cfg.database.user}:@${cfg.database.host}:${cfg.database.port}/${cfg.database.name}";
          };
          REDIS_URL = mkOption {
            description = "Redis instance used by Dramatiq and Flask-Limiter.";
            type = types.str;
            default =
              if cfg.redis.enable then
                "redis://${cfg.redis.host}:${toString cfg.redis.port}/${toString cfg.redis.database}"
              else
                "redis://";
          };
          HOST = mkOption {
            description = "Host";
            type = types.str;
            default = "127.0.0.1";
          };
          PORT = mkOption {
            description = "What port to run Fittrackee on.";
            type = types.port;
            default = 8000;
          };
          UI_URL = mkOption {
            description = "URL for FitTrackee";
            type = types.str;
            default = "http://127.0.0.1";
          };
          UPLOAD_FOLDER = mkOption {
            description = "Absolute path to the directory where uploads folder will be created.";
            type = types.str;
            default = cfg.stateDir;
          };
        };
      };
      default = { };
    };
    database = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Database host address.";
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Database host port.";
      };

      name = mkOption {
        type = types.str;
        default = "fittrackee";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "fittrackee";
        description = "Database user.";
      };

      socket = mkOption {
        type = types.nullOr types.path;
        default = if cfg.database.createDatabase then "/run/postgresql" else null;
        defaultText = literalExpression "null";
        example = "/run/postgresql";
        description = "Path to the unix socket file to use for authentication.";
      };

      createDatabase = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create a local database automatically.";
      };
    };

    redis = {
      enable = mkEnableOption "Whether to use redis at all";

      createLocally = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create a local redis automatically.";
      };

      name = lib.mkOption {
        type = types.str;
        default = "fittrackee";
        description = ''
          Name of the redis server.
          Only used if {option}`services.fittrackee.redis.createLocally` is set to true.
        '';
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Redis server address.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 6379;
        description = "Port of the redis server.";
      };

      database = lib.mkOption {
        type = types.int;
        default = 1;
        description = "Which redis db to use";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createDatabase -> (cfg.database.user == cfg.database.name);
        message = ''
          When creating a database via NixOS, the db user and db name must be equal!
          If you already have an existing DB+user and this assertion is new, you can safely set
          `services.fittrackee.createDatabase` to `false` because removal of `ensureUsers`
          and `ensureDatabases` doesn't have any effect.
        '';
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
    users.groups = mkIf (cfg.group == "fittrackee") { fittrackee = { }; };
    users.users = mkIf (cfg.user == "fittrackee") {
      fittrackee = {
        inherit (cfg) group;
        home = cfg.stateDir;
        description = "FitTrackee Daemon user";
        isSystemUser = true;
      };
    };

    services.postgresql = optionalAttrs cfg.database.createDatabase {
      enable = mkDefault true;

      extensions = ps: with ps; [ postgis ];
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
      initialScript = builtins.toFile "init.sql" ''
        CREATE USER ${cfg.database.user};
        CREATE SCHEMA ${cfg.database.name} AUTHORIZATION ${cfg.database.user};
        CREATE DATABASE ${cfg.database.name} OWNER ${cfg.database.user};

        \connect ${cfg.database.name}

        CREATE EXTENSION postgis;
      '';
    };

    services.redis.servers = optionalAttrs (cfg.redis.enable && cfg.redis.createLocally) {
      ${cfg.redis.name} = {
        inherit (cfg.redis) port;

        enable = true;
        bind = cfg.redis.host;
      };
    };

    systemd.services.fittrackee = {
      environment = lib.mapAttrs (_: value: toString value) cfg.settings;

      description = "Self-hosted outdoor activity tracker";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = optionals cfg.database.createDatabase [
        "postgresql.target"
      ];

      after = [
        "network.target"
        "postgres.service"
        "redis.service"
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        RestartSec = 1;
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/fittrackee";
        ExecStart = lib.getExe' cfg.package "fittrackee";
        ExecStartPre = "${lib.getExe' cfg.package "ftcli"} db upgrade";

        SyslogIdentifier = "fittrackee";
        StateDirectory = mkIf (cfg.stateDir == "/var/lib/fittrackee") "fittrackee";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != "") cfg.environmentFile;

        RemoveIPC = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        SystemCallFilter = [ "@system-service" ];
        ProtectSystem = "full";
        PrivateTmp = true;
        ProtectProc = "invisible";
        ProtectClock = true;
        ProcSubset = "pid";
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_LOCAL"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];

        LockPersonality = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
      };
    };
  };
  meta.maintainers = pkgs.fittrackee.meta.maintainers;
}
