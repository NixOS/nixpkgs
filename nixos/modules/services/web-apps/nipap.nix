{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nipap;
  iniFmt = pkgs.formats.ini { };

  configFile = iniFmt.generate "nipap.conf" cfg.settings;

  defaultUser = "nipap";
  defaultAuthBackend = "local";
  dataDir = "/var/lib/nipap";

  defaultServiceConfig = {
    WorkingDirectory = dataDir;
    User = cfg.user;
    Group = config.users.users."${cfg.user}".group;
    Restart = "on-failure";
    RestartSec = 30;
  };

  escapedHost = host: if lib.hasInfix ":" host then "[${host}]" else host;
in
{
  options.services.nipap = {
    enable = lib.mkEnableOption "global Neat IP Address Planner (NIPAP) configuration";

    user = lib.mkOption {
      type = lib.types.str;
      description = "User to use for running NIPAP services.";
      default = defaultUser;
    };

    settings = lib.mkOption {
      description = ''
        Configuration options to set in /etc/nipap/nipap.conf.
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = iniFmt.type;

        options = {
          nipapd = {
            listen = lib.mkOption {
              type = lib.types.str;
              default = "::1";
              description = "IP address to bind nipapd to.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 1337;
              description = "Port to bind nipapd to.";
            };

            foreground = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Remain in foreground rather than forking to background.";
            };
            debug = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable debug logging.";
            };

            db_host = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "PostgreSQL host to connect to. Empty means use UNIX socket.";
            };
            db_name = lib.mkOption {
              type = lib.types.str;
              default = cfg.user;
              defaultText = defaultUser;
              description = "Name of database to use on PostgreSQL server.";
            };
          };

          auth = {
            default_backend = lib.mkOption {
              type = lib.types.str;
              default = defaultAuthBackend;
              description = "Name of auth backend to use by default.";
            };
            auth_cache_timeout = lib.mkOption {
              type = lib.types.int;
              default = 3600;
              description = "Seconds to store cached auth entries for.";
            };
          };
        };
      };
    };

    authBackendSettings = lib.mkOption {
      description = ''
        auth.backends options to set in /etc/nipap/nipap.conf.
      '';

      default = {
        "${defaultAuthBackend}" = {
          type = "SqliteAuth";
          db_path = "${dataDir}/local_auth.db";
        };
      };

      type = lib.types.submodule {
        freeformType = iniFmt.type;
      };
    };

    nipapd = {
      enable = lib.mkEnableOption "nipapd server";
      package = lib.mkPackageOption pkgs "nipap" { };

      database.createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create a nipap database automatically.";
      };
    };

    nipap-www = {
      enable = lib.mkEnableOption "nipap-www server";
      package = lib.mkPackageOption pkgs "nipap-www" { };

      xmlrpcURIFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to file containing XMLRPC URI for use by web UI - this is a secret, since it contains auth credentials. If null, it will be initialized assuming that the auth database is local.";
      };

      workers = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Number of worker processes for Gunicorn to fork.";
      };
      umask = lib.mkOption {
        type = lib.types.str;
        default = "0";
        description = "umask for files written by Gunicorn, including UNIX socket.";
      };

      unixSocket = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to UNIX socket to bind to.";
        example = "/run/nipap/nipap-www.sock";
      };
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "::";
        description = "Host to bind to.";
      };
      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = 21337;
        description = "Port to bind to.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        systemd.tmpfiles.rules = [
          "d '${dataDir}' - ${cfg.user} ${config.users.users."${cfg.user}".group} - -"
        ];

        environment.etc."nipap/nipap.conf" = {
          source = configFile;
        };

        services.nipap.settings = lib.attrsets.mapAttrs' (name: value: {
          name = "auth.backends.${name}";
          inherit value;
        }) cfg.authBackendSettings;

        services.nipap.nipapd.enable = lib.mkDefault true;
        services.nipap.nipap-www.enable = lib.mkDefault true;

        environment.systemPackages = [
          cfg.nipapd.package
        ];
      }
      (lib.mkIf (cfg.user == defaultUser) {
        users.users."${defaultUser}" = {
          isSystemUser = true;
          group = defaultUser;
          home = dataDir;
        };
        users.groups."${defaultUser}" = { };
      })
      (lib.mkIf (cfg.nipapd.enable && cfg.nipapd.database.createLocally) {
        services.postgresql = {
          enable = true;
          extensions = ps: with ps; [ ip4r ];
          ensureUsers = [
            {
              name = cfg.user;
            }
          ];
          ensureDatabases = [ cfg.settings.nipapd.db_name ];
        };

        systemd.services.postgresql.serviceConfig.ExecStartPost =
          let
            sqlFile = pkgs.writeText "nipapd-setup.sql" ''
              CREATE EXTENSION IF NOT EXISTS ip4r;

              ALTER SCHEMA public OWNER TO "${cfg.user}";
              ALTER DATABASE "${cfg.settings.nipapd.db_name}" OWNER TO "${cfg.user}";
            '';
          in
          [
            ''
              ${lib.getExe' config.services.postgresql.finalPackage "psql"} -d "${cfg.settings.nipapd.db_name}" -f "${sqlFile}"
            ''
          ];
      })
      (lib.mkIf cfg.nipapd.enable {
        systemd.services.nipapd =
          let
            pkg = cfg.nipapd.package;
          in
          {
            description = "Neat IP Address Planner";
            after = [
              "network.target"
              "systemd-tmpfiles-setup.service"
            ]
            ++ lib.optional (cfg.settings.nipapd.db_host == "") "postgresql.target";
            requires = lib.optional (cfg.settings.nipapd.db_host == "") "postgresql.target";
            wantedBy = [ "multi-user.target" ];
            preStart = lib.optionalString (cfg.settings.auth.default_backend == defaultAuthBackend) ''
              # Create/upgrade local auth database
              umask 077
              ${pkg}/bin/nipap-passwd create-database >/dev/null 2>&1
              ${pkg}/bin/nipap-passwd upgrade-database >/dev/null 2>&1
            '';
            serviceConfig = defaultServiceConfig // {
              KillSignal = "SIGINT";
              ExecStart = ''
                ${pkg}/bin/nipapd \
                  --auto-install-db \
                  --auto-upgrade-db \
                  --foreground \
                  --no-pid-file
              '';
            };
          };
      })
      (lib.mkIf cfg.nipap-www.enable {
        assertions = [
          {
            assertion =
              cfg.nipap-www.xmlrpcURIFile == null -> cfg.settings.auth.default_backend == defaultAuthBackend;
            message = "If no XMLRPC URI secret file is specified, then the default auth backend must be in use to automatically generate credentials.";
          }
        ];

        # Ensure that _something_ exists in the [www] group.
        services.nipap.settings.www = lib.mkDefault { };

        systemd.services.nipap-www =
          let
            pkg = cfg.nipap-www.package;
          in
          {
            description = "Neat IP Address Planner web server";
            after = [
              "network.target"
              "systemd-tmpfiles-setup.service"
            ]
            ++ lib.optional cfg.nipapd.enable "nipapd.service";
            wantedBy = [ "multi-user.target" ];
            environment = {
              PYTHONPATH = pkg.pythonPath;
            };
            serviceConfig = defaultServiceConfig;
            script =
              let
                bind =
                  if cfg.nipap-www.unixSocket != null then
                    "unix:${cfg.nipap-www.unixSocket}"
                  else
                    "${escapedHost cfg.nipap-www.host}:${toString cfg.nipap-www.port}";
                generateXMLRPC = cfg.nipap-www.xmlrpcURIFile == null;
                xmlrpcURIFile = if generateXMLRPC then "${dataDir}/www_xmlrpc_uri" else cfg.nipap-www.xmlrpcURIFile;
              in
              ''
                test -f "${dataDir}/www_secret" || {
                  umask 0077
                  ${pkg.python}/bin/python -c "import secrets; print(secrets.token_hex())" > "${dataDir}/www_secret"
                }
                export FLASK_SECRET_KEY="$(cat "${dataDir}/www_secret")"

                # Ensure that we have an XMLRPC URI.
                ${
                  if generateXMLRPC then
                    ''
                      test -f "${dataDir}/www_xmlrpc_uri" || {
                        umask 0077
                        www_password="$(${pkg.python}/bin/python -c "import secrets; print(secrets.token_hex())")"
                        ${cfg.nipapd.package}/bin/nipap-passwd add --username nipap-www --password "''${www_password}" --name "User account for the web UI" --trusted

                        echo "http://nipap-www@${defaultAuthBackend}:''${www_password}@${escapedHost cfg.settings.nipapd.listen}:${toString cfg.settings.nipapd.port}" > "${xmlrpcURIFile}"
                      }
                    ''
                  else
                    ""
                }
                export FLASK_XMLRPC_URI="$(cat "${xmlrpcURIFile}")"

                exec "${pkg.gunicorn}/bin/gunicorn" \
                  --preload --workers ${toString cfg.nipap-www.workers} \
                  --pythonpath "${pkg}/${pkg.python.sitePackages}" \
                  --bind ${bind} --umask ${cfg.nipap-www.umask} \
                  "nipapwww:create_app()"
              '';
          };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ lukegb ];
}
