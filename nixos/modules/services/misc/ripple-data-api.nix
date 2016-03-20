{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rippleDataApi;

  deployment_env_config = builtins.toJSON {
    production = {
      port = toString cfg.port;
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
      username = optionalString (cfg.couchdb.pass != "") cfg.couchdb.user;
      password = optionalString (cfg.couchdb.pass != "") cfg.couchdb.pass;
      host = cfg.couchdb.host;
      port = cfg.couchdb.port;
      database = cfg.couchdb.db;
      protocol = "http";
    };
  };

  importer_config = builtins.toJSON {
    queueLength = 20;
    logLevel = cfg.importer.logLevel;
    logFile = null;
    ripple = {
      trace = false;
      allow_partial_history = false;
      servers = cfg.importer.servers;
    };
    couchdb = {
      username = optionalString (cfg.couchdb.pass != "") cfg.couchdb.user;
      password = optionalString (cfg.couchdb.pass != "") cfg.couchdb.pass;
      host = cfg.couchdb.host;
      port = cfg.couchdb.port;
      database = cfg.couchdb.db;
      protocol = "http";
    };
  };

in {
  options = {
    services.rippleDataApi = {
      enable = mkEnableOption "ripple data api";

      port = mkOption {
        description = "Ripple data api port";
        default = 5993;
        type = types.int;
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
          type = types.int;
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
          type = types.int;
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

      importer = {
        logLevel = mkOption {
          description = "Ripple data importer log level.";
          default = 3;
          type = types.int;
        };

        servers = mkOption {
          description = "Ripple data importer list of rippled servers to import from.";
          default = [
            { host = "s-west.ripple.com"; }
            { host = "s-east.ripple.com"; }
          ];
          type = types.listOf types.optionSet;
          options = [{
            host = mkOption {
              description = "Ripple data importer rippled host.";
              type = types.str;
            };

            port = mkOption {
              description = "Ripple data importer rippled port.";
              type = types.int;
              default = 443;
            };

            secure = mkOption {
              description = "Ripple data importer rippled enable ssl.";
              type = types.bool;
              default = true;
            };
          }];
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    services.couchdb.enable = mkDefault true;
    services.couchdb.bindAddress = mkDefault "0.0.0.0";
    services.redis.enable = mkDefault true;

    systemd.services.ripple-data-api = {
      after = [ "couchdb.service" "redis.service" "ripple-data-api-importer.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        NODE_ENV = "production";
        DEPLOYMENT_ENVS_CONFIG = pkgs.writeText "deployment.environment.json" deployment_env_config;
        DB_CONFIG = pkgs.writeText "db.config.json" db_config;
      };

      serviceConfig = {
        ExecStart = "${pkgs.nodePackages.ripple-data-api}/bin/api";
        Restart = "always";
        User = "ripple-data-api";
      };
    };

    systemd.services.ripple-data-importer = {
      after = [ "couchdb.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.curl pkgs.nodejs ];

      environment = {
        NODE_ENV = "production";
        DEPLOYMENT_ENVS_CONFIG = pkgs.writeText "deployment.environment.json" deployment_env_config;
        DB_CONFIG = pkgs.writeText "db.config.json" db_config;
      };

      script = ''
        node \
          ${pkgs.nodePackages.ripple-historical-database}/lib/node_modules/ripple-historical-database/import/live.js \
            --type couchdb;
      '';

      serviceConfig = {
        Restart = "always";
        User = "ripple-data-api";
        WorkingDirectory = pkgs.writeTextFile {
          name = "ripple-importer-config";
          text = importer_config;
          destination = "/config/import.config.json";
        };
      };

      preStart = mkMerge [
        (mkIf (cfg.couchdb.create) ''
          HOST="http://${optionalString (cfg.couchdb.pass != "") "${cfg.couchdb.user}:${cfg.couchdb.pass}@"}${cfg.couchdb.host}:${toString cfg.couchdb.port}"
          curl -X PUT $HOST/${cfg.couchdb.db} || true
        '')
        "${pkgs.nodePackages.ripple-data-api}/bin/update-views"
      ];
    };

    users.extraUsers = singleton {
      name = "ripple-data-api";
      description = "Ripple data api user";
      uid = config.ids.uids.ripple-data-api;
    };
  };
}
