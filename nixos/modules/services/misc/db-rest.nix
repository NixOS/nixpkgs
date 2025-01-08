{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.db-rest;
in
{
  options = {
    services.db-rest = {
      enable = lib.mkEnableOption "db-rest service";

      user = lib.mkOption {
        type = lib.types.str;
        default = "db-rest";
        description = "User account under which db-rest runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "db-rest";
        description = "Group under which db-rest runs.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host address the db-rest server should listen on.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "The port the db-rest server should listen on.";
      };

      redis = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable caching with redis for db-rest.";
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Configure a local redis server for db-rest.";
        };

        host = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Redis host.";
        };

        port = lib.mkOption {
          type = with lib.types; nullOr port;
          default = null;
          description = "Redis port.";
        };

        user = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Optional username used for authentication with redis.";
        };

        passwordFile = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          example = "/run/keys/db-rest/pasword-redis-db";
          description = "Path to a file containing the redis password.";
        };

        useSSL = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use SSL if using a redis network connection.";
        };
      };

      package = lib.mkPackageOption pkgs "db-rest" { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.redis.enable && !cfg.redis.createLocally)
          -> (cfg.redis.host != null && cfg.redis.port != null);
        message = ''
          {option}`services.db-rest.redis.createLocally` and redis network connection ({option}`services.db-rest.redis.host` or {option}`services.db-rest.redis.port`) enabled. Disable either of them.
        '';
      }
      {
        assertion = (cfg.redis.enable && !cfg.redis.createLocally) -> (cfg.redis.passwordFile != null);
        message = ''
          {option}`services.db-rest.redis.createLocally` is disabled, but {option}`services.db-rest.redis.passwordFile` is not set.
        '';
      }
    ];

    systemd.services.db-rest = lib.mkMerge [
      {
        description = "db-rest service";
        after = [ "network.target" ] ++ lib.optional cfg.redis.createLocally "redis-db-rest.service";
        requires = lib.optional cfg.redis.createLocally "redis-db-rest.service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = cfg.package;
          User = cfg.user;
          Group = cfg.group;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          MemoryDenyWriteExecute = false;
          LoadCredential = lib.optional (
            cfg.redis.enable && cfg.redis.passwordFile != null
          ) "REDIS_PASSWORD:${cfg.redis.passwordFile}";
          ExecStart = lib.mkDefault "${cfg.package}/bin/db-rest";

          RemoveIPC = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          ProtectHostname = true;
          LockPersonality = true;
          ProtectKernelTunables = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          ProtectSystem = "strict";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectHome = true;
          PrivateUsers = true;
          PrivateTmp = true;
          CapabilityBoundingSet = "";
        };
        environment = {
          NODE_ENV = "production";
          NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
          HOSTNAME = cfg.host;
          PORT = toString cfg.port;
        };
      }
      (lib.mkIf cfg.redis.enable (
        if cfg.redis.createLocally then
          { environment.REDIS_URL = config.services.redis.servers.db-rest.unixSocket; }
        else
          {
            script =
              let
                username = lib.optionalString (cfg.redis.user != null) (cfg.redis.user);
                host = cfg.redis.host;
                port = toString cfg.redis.port;
                protocol = if cfg.redis.useSSL then "rediss" else "redis";
              in
              ''
                export REDIS_URL="${protocol}://${username}:$(${config.systemd.package}/bin/systemd-creds cat REDIS_PASSWORD)@${host}:${port}"
                exec ${cfg.package}/bin/db-rest
              '';
          }
      ))
    ];

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "db-rest") {
        db-rest = {
          isSystemUser = true;
          group = cfg.group;
        };
      })
      (lib.mkIf cfg.redis.createLocally { ${cfg.user}.extraGroups = [ "redis-db-rest" ]; })
    ];

    users.groups = lib.mkIf (cfg.group == "db-rest") { db-rest = { }; };

    services.redis.servers.db-rest.enable = cfg.redis.enable && cfg.redis.createLocally;
  };
  meta.maintainers = with lib.maintainers; [ marie ];
}
