{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.oncall;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "oncall_extra_settings.yaml" cfg.settings;

in
{
  options.services.oncall = {

    enable = lib.mkEnableOption "Oncall web app";

    package = lib.mkPackageOption pkgs "oncall" { };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create the database and database user locally.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          oncall_host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "FQDN for the Oncall instance.";
          };
          db.conn = {
            kwargs = {
              user = lib.mkOption {
                type = lib.types.str;
                default = "oncall";
                description = "Database user.";
              };
              host = lib.mkOption {
                type = lib.types.str;
                default = "localhost";
                description = "Database host.";
              };
              database = lib.mkOption {
                type = lib.types.str;
                default = "oncall";
                description = "Database name.";
              };
            };
            str = lib.mkOption {
              type = lib.types.str;
              default = "%(scheme)s://%(user)s@%(host)s:%(port)s/%(database)s?charset=%(charset)s&unix_socket=/run/mysqld/mysqld.sock";
              description = ''
                Database connection scheme. The default specifies the
                connection through a local socket.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://github.com/linkedin/oncall/blob/master/configs/config.yaml)
        and the administration part in the
        [offical documentation](https://oncall.tools/docs/admin_guide.html).
      '';
    };

    secrets = lib.mkOption {
      type = with lib.types; listOf path;
      description = ''
        A list of files containing the various secrets. Files should be formatted
        in the YAML format.
      '';
      default = [ ];
    };

  };

  config = lib.mkIf cfg.enable {

    services.oncall.settings = lib.mkMerge [
      ({
        debug = lib.mkDefault false;
        require_auth = lib.mkDefault true;
        auth.debug = lib.mkDefault false;
      })
    ];

    services.uwsgi = {
      enable = true;
      plugins = [ "python3" ];
      package = lib.mkForce (
        pkgs.uwsgi.override {
          python3 = pkgs.python311;
          plugins = [ "python3" ];
        }
      );
      user = "oncall";
      instance = {
        type = "emperor";
        vassals = {
          oncall = {
            type = "normal";
            env = [
              "PYTHONPATH=${pkgs.oncall.pythonPath}"
              "ONCALL_EXTRA_CONFIG=${lib.concatStringsSep "," ([ configFile ] ++ cfg.secrets)}"
              "STATIC_ROOT=/var/lib/oncall"
            ];
            module = "oncall.app:get_wsgi_app()";
            socket = "${config.services.uwsgi.runDir}/oncall.sock";
            socketGroup = "nginx";
            immediate-gid = "nginx";
            chmod-socket = "770";
            pyargv = "${pkgs.oncall}/configs/config.yaml";
            buffer-size = 32768;
          };
        };
      };
    };

    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.settings.oncall_host}".locations = {
        "/".extraConfig = "uwsgi_pass unix://${config.services.uwsgi.runDir}/oncall.sock;";
      };
      proxyTimeout = lib.mkDefault "120s";
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.settings.db.conn.kwargs.database ];
      ensureUsers = [
        {
          name = cfg.settings.db.conn.kwargs.user;
          ensurePermissions = {
            "${cfg.settings.db.conn.kwargs.database}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    users.users.oncall = {
      group = "nginx";
      isSystemUser = true;
    };

    systemd = {
      services = {
        uwsgi.serviceConfig.StateDirectory = "oncall";
        oncall-setup-database = lib.mkIf cfg.database.createLocally {
          description = "Set up Oncall database";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          wantedBy = [ "uwsgi.service" ];
          after = [ "mysql.service" ];
          script =
            let
              mysql = "${lib.getExe' config.services.mysql.package "mysql"}";
            in
            ''
              if [ ! -f /var/lib/oncall/.dbexists ]; then
                # Load database schema provided with package
                ${mysql} ${cfg.settings.db.conn.kwargs.database} < ${cfg.package}/db/schema.v0.sql
                ${mysql} ${cfg.settings.db.conn.kwargs.database} < ${cfg.package}/db/schema-update.v0-1602184489.sql
                touch /var/lib/oncall/.dbexists
              fi
            '';
        };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
