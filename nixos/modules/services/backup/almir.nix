{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.almir;

  bconsoleconf = pkgs.writeText "bconsole.conf"
    ''
      Director {
        Name = ${cfg.director_name}
        DIRport = ${toString cfg.director_port}
        address = ${cfg.director_address}
        Password = "${cfg.director_password}"
      }
    '';

  productionini = pkgs.writeText "production.ini"
    ''
[app:main]
use = egg:almir

pyramid.reload_templates = false
pyramid.debug_authorization = false
pyramid.debug_notfound = false
pyramid.debug_routematch = false
pyramid.debug_templates = false
pyramid.default_locale_name = en
pyramid.includes =
    pyramid_exclog
exclog.extra_info = true

sqlalchemy.url = ${cfg.sqlalchemy_engine_url}
timezone = ${cfg.timezone}
bconsole_config = ${bconsoleconf}

[server:main]
use = egg:waitress#main
host = 127.0.0.1
port = ${toString cfg.port}


# Begin logging configuration

[loggers]
keys = root, almir, sqlalchemy, exc_logger

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console

[logger_almir]
level = WARN
handlers =
qualname = almir

[logger_exc_logger]
level = ERROR
handlers =
qualname = exc_logger

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine
# "level = INFO" logs SQL queries.
# "level = DEBUG" logs SQL queries and results.
# "level = WARN" logs neither.  (Recommended for production systems.)

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(asctime)s %(levelname)-5.5s [%(name)s][%(threadName)s] %(message)s
    '';
in {
  options = {
    services.almir = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Almir web server. Also configures postgresql database and installs bacula.
        '';
      };

      port = mkOption {
        default = 35000;
        type = types.uniq types.int;
        description = ''
          Port for Almir web server to listen on.
        '';
      };

      timezone = mkOption {
	description = ''
         Timezone as specified in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
        '';
        example = "Europe/Ljubljana";
      };

      sqlalchemy_engine_url = mkOption {
        example = ''
          postgresql://bacula:bacula@localhost:5432/bacula
          mysql+mysqlconnector://<user>:<password>@<hostname>/<database>'
          sqlite:////var/lib/bacula/bacula.db'
        '';
	description = ''
         Define SQL database connection to bacula catalog as specified in http://docs.sqlalchemy.org/en/latest/core/engines.html#database-urls
        '';
      };

      director_name = mkOption {
        description = ''
          Name of the Director to connect with bconsole.
        '';
      };

      director_password = mkOption {
        description = ''
          Password for Director to connect with bconsole.
        '';
      };

      director_port = mkOption {
        default = 9101;
        type = types.int;
        description = ''
          Port for Director to connect with bconsole.
        '';
      };

      director_address = mkOption {
        default = "127.0.0.1";
        description = ''
          IP/Hostname for Director to connect with bconsole.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.almir = {
      after = [ "network.target" "postgresql.service" ];
      description = "Almir web app";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.almir ];
      serviceConfig.ExecStart = "${pkgs.pythonPackages.almir}/bin/pserve ${productionini}";
    };

    environment.systemPackages = [ pkgs.pythonPackages.almir ];

    users.extraUsers.almir = {
      group = "almir";
      uid = config.ids.uids.almir;
      createHome = true;
      shell = "${pkgs.bash}/bin/bash";
    };

    users.extraGroups.almir.gid = config.ids.gids.almir;
  };
}
