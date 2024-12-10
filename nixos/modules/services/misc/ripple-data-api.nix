{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.rippleDataApi;

  deployment_env_config = builtins.toJSON {
    production = {
      port = toString cfg.port;
      maxSockets = 150;
      batchSize = 100;
      startIndex = 32570;
      rippleds = cfg.rippleds;
      redis = {
        enable = cfg.redis.enable;
        host = cfg.redis.host;
        port = cfg.redis.port;
        options.auth_pass = null;
      };
    };
  };

  db_config = builtins.toJSON {
    production = {
      username = optional (cfg.couchdb.pass != "") cfg.couchdb.user;
      password = optional (cfg.couchdb.pass != "") cfg.couchdb.pass;
      host = cfg.couchdb.host;
      port = cfg.couchdb.port;
      database = cfg.couchdb.db;
      protocol = "http";
    };
  };

in
{
  options = {
    services.rippleDataApi = {
      enable = mkEnableOption "ripple data api";

      port = mkOption {
        description = "Ripple data api port";
        default = 5993;
        type = types.port;
      };

      importMode = mkOption {
        description = "Ripple data api import mode.";
        default = "liveOnly";
        type = types.enum [
          "live"
          "liveOnly"
        ];
      };

      minLedger = mkOption {
        description = "Ripple data api minimal ledger to fetch.";
        default = null;
        type = types.nullOr types.int;
      };

      maxLedger = mkOption {
        description = "Ripple data api maximal ledger to fetch.";
        default = null;
        type = types.nullOr types.int;
      };

      redis = {
        enable = mkOption {
          description = "Whether to enable caching of ripple data to redis.";
          default = true;
          type = types.bool;
        };

        host = mkOption {
          description = "Ripple data api redis host.";
          default = "localhost";
          type = types.str;
        };

        port = mkOption {
          description = "Ripple data api redis port.";
          default = 5984;
          type = types.port;
        };
      };

      couchdb = {
        host = mkOption {
          description = "Ripple data api couchdb host.";
          default = "localhost";
          type = types.str;
        };

        port = mkOption {
          description = "Ripple data api couchdb port.";
          default = 5984;
          type = types.port;
        };

        db = mkOption {
          description = "Ripple data api couchdb database.";
          default = "rippled";
          type = types.str;
        };

        user = mkOption {
          description = "Ripple data api couchdb username.";
          default = "rippled";
          type = types.str;
        };

        pass = mkOption {
          description = "Ripple data api couchdb password.";
          default = "";
          type = types.str;
        };

        create = mkOption {
          description = "Whether to create couchdb database needed by ripple data api.";
          type = types.bool;
          default = true;
        };
      };

      rippleds = mkOption {
        description = "List of rippleds to be used by ripple data api.";
        default = [
          "http://s_east.ripple.com:51234"
          "http://s_west.ripple.com:51234"
        ];
        type = types.listOf types.str;
      };
    };
  };

  config = mkIf (cfg.enable) {
    services.couchdb.enable = mkDefault true;
    services.couchdb.bindAddress = mkDefault "0.0.0.0";
    services.redis.enable = mkDefault true;

    systemd.services.ripple-data-api = {
      after = [
        "couchdb.service"
        "redis.service"
        "ripple-data-api-importer.service"
      ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        NODE_ENV = "production";
        DEPLOYMENT_ENVS_CONFIG = pkgs.writeText "deployment.environment.json" deployment_env_config;
        DB_CONFIG = pkgs.writeText "db.config.json" db_config;
      };

      serviceConfig = {
        ExecStart = "${pkgs.ripple-data-api}/bin/api";
        Restart = "always";
        User = "ripple-data-api";
      };
    };

    systemd.services.ripple-data-importer = {
      after = [ "couchdb.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.curl ];

      environment = {
        NODE_ENV = "production";
        DEPLOYMENT_ENVS_CONFIG = pkgs.writeText "deployment.environment.json" deployment_env_config;
        DB_CONFIG = pkgs.writeText "db.config.json" db_config;
        LOG_FILE = "/dev/null";
      };

      serviceConfig =
        let
          importMode =
            if cfg.minLedger != null && cfg.maxLedger != null then
              "${toString cfg.minLedger} ${toString cfg.maxLedger}"
            else
              cfg.importMode;
        in
        {
          ExecStart = "${pkgs.ripple-data-api}/bin/importer ${importMode} debug";
          Restart = "always";
          User = "ripple-data-api";
        };

      preStart = mkMerge [
        (mkIf (cfg.couchdb.create) ''
          HOST="http://${
            optionalString (cfg.couchdb.pass != "") "${cfg.couchdb.user}:${cfg.couchdb.pass}@"
          }${cfg.couchdb.host}:${toString cfg.couchdb.port}"
          curl -X PUT $HOST/${cfg.couchdb.db} || true
        '')
        "${pkgs.ripple-data-api}/bin/update-views"
      ];
    };

    users.users.ripple-data-api = {
      description = "Ripple data api user";
      isSystemUser = true;
      group = "ripple-data-api";
    };
    users.groups.ripple-data-api = { };
  };
}
