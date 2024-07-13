{ pkgs, lib, config, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.services.gotify;
in {
  options = {
    services.gotify = {
      enable = mkEnableOption "Gotify webserver";

      port = mkOption {
        type = types.port;
        description = ''
          Port the server listens to.
        '';
      };

      stateDirectoryName = mkOption {
        type = types.str;
        default = "gotify-server";
        description = ''
          The name of the directory below {file}`/var/lib` where
          gotify stores its runtime data.
        '';
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" "mysql" "postgres" ];
          default = "sqlite3";
          description = ''
            The type of database gotify should connect to.
          '';
        };

        path = mkOption {
          type = types.str;
          default = "data/gotify.db";
          description = ''
            The path of the sqlite3 database.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            The hostname of the database to connect to.
          '';
        };

        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = ''
            The port of the database to connect to.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "gotify";
          description = ''
            The username of the database to connect to.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "gotifydb";
          description = ''
            The name of the database to connect to.
          '';
        };

        useSSL = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether the database connection should be secured by SSL / TLS.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The path to a file containing the database password.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gotify-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Simple server for sending and receiving messages";

      environment = {
        GOTIFY_SERVER_PORT = toString cfg.port;
        GOTIFY_DATABASE_DIALECT = cfg.database.type;
        GOTIFY_DATABASE_CONNECTION =
          if cfg.database.type == "sqlite3" then cfg.database.path
          else if cfg.database.type == "mysql" then "${cfg.database.user}:$DB_PASSWORD@tcp(${cfg.database.host}:${toString cfg.database.port})/${cfg.database.name}?charset=utf8&parseTime=True&loc=Local"
          else ''sslmode=${if cfg.database.useSSL then "enable" else "disable"} host=${cfg.database.host} port=${toString cfg.database.port} user=${cfg.database.user} dbname=${cfg.database.name} password="$DB_PASSWORD"'';
      };

      serviceConfig = {
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        StateDirectory = cfg.stateDirectoryName;
        Restart = "always";
        DynamicUser = "yes";
        ExecStart = "${pkgs.gotify-server}/bin/server";
        EnvironmentFile = [ cfg.database.passwordFile ];
      };
    };
  };
}
