{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.nominatim;

  localDb = cfg.database.host == "localhost";
  uiPackage = cfg.ui.package.override { customConfig = cfg.ui.config; };
in
{
  options.services.nominatim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable nominatim.

        Also enables nginx virtual host management. Further nginx configuration
        can be done by adapting `services.nginx.virtualHosts.<name>`.
        See [](#opt-services.nginx.virtualHosts).
      '';
    };

    package = lib.mkPackageOption pkgs.python3Packages "nominatim-api" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname to use for the nginx vhost.";
      example = "nominatim.example.com";
    };

    settings = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          NOMINATIM_REPLICATION_URL = "https://planet.openstreetmap.org/replication/minute";
          NOMINATIM_REPLICATION_MAX_DIFF = "100";
        }
      '';
      description = ''
        Nominatim configuration settings.
        For the list of available configuration options see
        <https://nominatim.org/release-docs/latest/customize/Settings>.
      '';
    };

    ui = {
      package = lib.mkPackageOption pkgs "nominatim-ui" { };

      config = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Nominatim UI configuration placed to theme/config.theme.js file.

          For the list of available configuration options see
          <https://github.com/osm-search/nominatim-ui/blob/master/dist/config.defaults.js>.
        '';
        example = ''
          Nominatim_Config.Page_Title='My Nominatim instance';
          Nominatim_Config.Nominatim_API_Endpoint='https://localhost/';
        '';
      };
    };

    database = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Host of the postgresql server. If not set to `localhost`, Nominatim
          database and postgresql superuser with appropriate permissions must
          exist on target host.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "Port of the postgresql database.";
      };

      dbname = lib.mkOption {
        type = lib.types.str;
        default = "nominatim";
        description = "Name of the postgresql database.";
      };

      superUser = lib.mkOption {
        type = lib.types.str;
        default = "nominatim";
        description = ''
          Postgresql database superuser used to create Nominatim database and
          import data. If `database.host` is set to `localhost`, a unix user and
          group of the same name will be automatically created.
        '';
      };

      apiUser = lib.mkOption {
        type = lib.types.str;
        default = "nominatim-api";
        description = ''
          Postgresql database user with read-only permissions used for Nominatim
          web API service.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Password file used for Nominatim database connection.
          Must be readable only for the Nominatim web API user.

          The file must be a valid `.pgpass` file as described in:
          <https://www.postgresql.org/docs/current/libpq-pgpass.html>

          In most cases, the following will be enough:
          ```
          *:*:*:*:<password>
          ```
        '';
      };

      extraConnectionParams = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Extra Nominatim database connection parameters.

          Format:
          <param1>=<value1>;<param2>=<value2>

          See <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-PARAMKEYWORDS>.
        '';
      };
    };
  };

  config =
    let
      nominatimSuperUserDsn =
        "pgsql:dbname=${cfg.database.dbname};"
        + "user=${cfg.database.superUser}"
        + lib.optionalString (cfg.database.extraConnectionParams != null) (
          ";" + cfg.database.extraConnectionParams
        );

      nominatimApiDsn =
        "pgsql:dbname=${cfg.database.dbname}"
        + lib.optionalString (!localDb) (
          ";host=${cfg.database.host};"
          + "port=${toString cfg.database.port};"
          + "user=${cfg.database.apiUser}"
        )
        + lib.optionalString (cfg.database.extraConnectionParams != null) (
          ";" + cfg.database.extraConnectionParams
        );
    in
    lib.mkIf cfg.enable {
      # CLI package
      environment.systemPackages = [ pkgs.nominatim ];

      # Database
      users.users.${cfg.database.superUser} = lib.mkIf localDb {
        group = cfg.database.superUser;
        isSystemUser = true;
        createHome = false;
      };
      users.groups.${cfg.database.superUser} = lib.mkIf localDb { };

      services.postgresql = lib.mkIf localDb {
        enable = true;
        extensions = ps: with ps; [ postgis ];
        ensureUsers = [
          {
            name = cfg.database.superUser;
            ensureClauses.superuser = true;
          }
          {
            name = cfg.database.apiUser;
          }
        ];
      };

      # TODO: add nominatim-update service

      systemd.services.nominatim-init = lib.mkIf localDb {
        after = [ "postgresql-setup.service" ];
        requires = [ "postgresql-setup.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = cfg.database.superUser;
          RemainAfterExit = true;
          PrivateTmp = true;
        };
        script = ''
          sql="SELECT COUNT(*) FROM pg_database WHERE datname='${cfg.database.dbname}'"
          db_exists=$(${pkgs.postgresql}/bin/psql --dbname postgres -tAc "$sql")

          if [ "$db_exists" == "0" ]; then
            ${lib.getExe pkgs.nominatim} import --prepare-database
          else
            echo "Database ${cfg.database.dbname} already exists. Skipping ..."
          fi
        '';
        path = [
          pkgs.postgresql
        ];
        environment = {
          NOMINATIM_DATABASE_DSN = nominatimSuperUserDsn;
          NOMINATIM_DATABASE_WEBUSER = cfg.database.apiUser;
        }
        // cfg.settings;
      };

      # Web API service
      users.users.${cfg.database.apiUser} = {
        group = cfg.database.apiUser;
        isSystemUser = true;
        createHome = false;
      };
      users.groups.${cfg.database.apiUser} = { };

      systemd.services.nominatim = {
        after = [ "network.target" ] ++ lib.optionals localDb [ "nominatim-init.service" ];
        requires = lib.optionals localDb [ "nominatim-init.service" ];
        bindsTo = lib.optionals localDb [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.database.apiUser;
          ExecStart = ''
            ${pkgs.python3Packages.gunicorn}/bin/gunicorn \
              --bind unix:/run/nominatim.sock \
              --workers 4 \
              --worker-class uvicorn.workers.UvicornWorker "nominatim_api.server.falcon.server:run_wsgi()"
          '';
          Environment = lib.optional (
            cfg.database.passwordFile != null
          ) "PGPASSFILE=${cfg.database.passwordFile}";
          ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
          KillMode = "mixed";
          TimeoutStopSec = 5;
        };
        environment = {
          PYTHONPATH =
            with pkgs.python3Packages;
            pkgs.python3Packages.makePythonPath [
              cfg.package
              falcon
              uvicorn
            ];
          NOMINATIM_DATABASE_DSN = nominatimApiDsn;
          NOMINATIM_DATABASE_WEBUSER = cfg.database.apiUser;
        }
        // cfg.settings;
      };

      systemd.sockets.nominatim = {
        before = [ "nominatim.service" ];
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = "/run/nominatim.sock";
          SocketUser = cfg.database.apiUser;
          SocketGroup = config.services.nginx.group;
        };
      };

      services.nginx = {
        enable = true;
        appendHttpConfig = ''
          map $args $format {
              default                  default;
              ~(^|&)format=html(&|$)   html;
          }

          map $uri/$format $forward_to_ui {
              default               0;   # No forwarding by default.

              # Redirect to HTML UI if explicitly requested.
              ~/reverse.*/html      1;
              ~/search.*/html       1;
              ~/lookup.*/html       1;
              ~/details.*/html      1;
          }
        '';
        upstreams.nominatim = {
          servers = {
            "unix:/run/nominatim.sock" = { };
          };
        };
        virtualHosts = {
          ${cfg.hostName} = {
            forceSSL = lib.mkDefault true;
            enableACME = lib.mkDefault true;
            locations = {
              "= /" = {
                extraConfig = ''
                  return 301 $scheme://$http_host/ui/search.html;
                '';
              };
              "/" = {
                proxyPass = "http://nominatim";
                extraConfig = ''
                  if ($forward_to_ui) {
                      rewrite ^(/[^/.]*) /ui$1.html redirect;
                  }
                '';
              };
              "/ui/" = {
                alias = "${uiPackage}/";
              };
            };
          };
        };
      };
    };
}
