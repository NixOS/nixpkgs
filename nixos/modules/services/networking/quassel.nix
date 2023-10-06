{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.quassel;
  opt = options.services.quassel;
  quassel = cfg.package;
  user = if cfg.user != null then cfg.user else "quassel";
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "quassel" "certificateFile" ] [ "services" "quassel" "settings" "ssl" "certFile" ])
    (mkRenamedOptionModule [ "services" "quassel" "requireSSL" ] [ "services" "quassel" "settings" "ssl" "required" ])
  ];

  options = {
    services.quassel = {
      enable = mkEnableOption (lib.mdDoc "the Quassel IRC client daemon");

      package = lib.mkPackageOptionMD pkgs "quasselDaemon" { };

      user = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          The existing user the Quassel daemon should run as. If left empty, a default "quassel" user will be created.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to an environment file loaded for the quassel service.

          This can be used to securely store tokens and secrets outside of the world-readable Nix store.
          For example to inject the `DB_PSQL_PASSWORD` and `AUTH_LDAP_BIND_PASSWORD` variables instead
          of setting {option}`services.quassel.settings.db.psql.password` and {option}`services.quassel.settings.auth.ldap.bindPassword`.

          ::: {.note}
          Since this file is read by systemd, it may have permission 0400 and be owned by root.
          :::
        '';
        example = ''
          # Example Content of the File
          DB_PSQL_PASSWORD=changeme
          AUTH_LDAP_BIND_PASSWORD=changemetoo
        '';
      };

      settings = mkOption {
        description = lib.mdDoc ''
          Configuration for quassel daemon.
        '';
        type = types.submodule {
          options = {
            listen = mkOption {
              type = types.listOf types.str;
              default = [ "127.0.0.1" "::1" ];
              description = lib.mdDoc ''
                The address(es) quasselcore will listen on.
              '';
            };

            port = mkOption {
              default = 4242;
              type = types.port;
              description = lib.mdDoc ''
                The port quasselcore will listen at.
              '';
            };

            dataDir = mkOption {
              default = "/home/${user}/.config/quassel-irc.org";
              defaultText = literalExpression ''
                "/home/''${config.${opt.user}}/.config/quassel-irc.org"
              '';
              type = types.path;
              description = lib.mdDoc ''
                The directory holding configuration files, the SQlite database and the SSL Cert.
              '';
            };

            useDeclarativeConfig = mkOption {
              default = false;
              type = types.bool;
              description = lib.mdDoc ''
                Configure quassels authenticator and database settings using the
                {option}`services.quassel.settings.auth` and {option}`services.quassel.settings.db` sections.

                Overrides whatever configuration for the database and authentication you have made using the setup wizard.
              '';
            };

            ident = mkOption {
              description = lib.mdDoc ''
                Configuration for quassels internal ident daemon.
              '';
              default = { };
              type = types.submodule {
                options = {
                  enable = lib.mkEnableOption (lib.mdDoc "internal ident daemon.");

                  strict = mkOption {
                    type = types.bool;
                    default = false;
                    description = lib.mdDoc ''
                      Use users quasselcore username as ident reply. Ignores each user's configured ident setting.
                    '';
                  };

                  listen = mkOption {
                    default = [ "127.0.0.1" "::1" ];
                    type = types.listOf types.str;
                    description = lib.mdDoc ''
                      The address(es) quasselcore will listen on for ident requests.
                    '';
                  };

                  port = mkOption {
                    default = 10113;
                    type = types.port;
                    description = lib.mdDoc ''
                      The port quasselcore will listen at for ident requests.
                    '';
                  };
                };
              };
            };

            oidentd = mkOption {
              description = lib.mdDoc ''
                Configuration for quassels integration with oidentd.
              '';
              default = { };
              type = types.submodule {
                options = {
                  enable = lib.mkEnableOption (lib.mdDoc "oidentd integration.");

                  configFile = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = lib.mdDoc ''
                      Set path to oidentd configuration file.
                    '';
                  };
                };
              };
            };

            ssl = mkOption {
              default = { };
              description = lib.mdDoc ''
                Configuration for quassel ssl
              '';
              type = types.submodule {
                options = {
                  required = mkOption {
                    type = types.bool;
                    default = false;
                    description = lib.mdDoc ''
                      Require SSL for remote (non-loopback) client connections.
                    '';
                  };

                  certFile = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = lib.mdDoc ''
                      Specify the path to the SSL certificate. Passed to quassel using systemd's LoadCredential.

                      ::: {.note}
                      Since this file is read by systemd, it may have permission 0400 and be owned by root.
                      :::
                    '';
                  };

                  keyFile = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = lib.mdDoc ''
                      Specify the path to the SSL key. Passed to quassel using systemd's LoadCredential.

                      ::: {.note}
                      Since this file is read by systemd, it may have permission 0400 and be owned by root.
                      :::
                    '';
                  };
                };
              };
            };

            metrics = mkOption {
              description = lib.mdDoc ''
                Export metrics in prometheus format
              '';
              default = { };
              type = types.submodule {
                options = {
                  enable = lib.mkEnableOption (lib.mdDoc "prometheus metrics API.");

                  listen = mkOption {
                    default = [ "127.0.0.1" "::1" ];
                    type = types.listOf types.str;
                    description = lib.mdDoc ''
                      The address(es) quasselcore will listen on for metrics requests.
                    '';
                  };

                  port = mkOption {
                    default = 9558;
                    type = types.port;
                    description = lib.mdDoc ''
                      The port quasselcore will listen at for metrics requests.
                    '';
                  };
                };
              };
            };

            logLevel = mkOption {
              type = types.enum [ "Debug" "Info" "Warning" "Error" ];
              default = "Info";
              description = lib.mdDoc ''
                Log level of the quassel core.
              '';
            };

            db = mkOption {
              default = { };
              description = lib.mdDoc ''
                Configuration for quassel database
              '';
              type = types.submodule {
                options = {
                  backend = mkOption {
                    type = types.enum [ "sqlite" "postgresql" ];
                    default = "sqlite";
                    apply = value: if value == "sqlite" then "SQLite" else "PostgreSQL";
                    description = lib.mdDoc ''
                      Specify the database backend.

                      In case SQLite is used, the database will be stored in `''${services.quassel.settings.dataDir}/quassel-storage.sqlite`
                    '';
                  };

                  pgsql = mkOption {
                    description = lib.mdDoc ''
                      Configuration for PostgreSQL Connection if {option}`services.quassel.settings.db.type` is set to "PostgreSQL".

                      TCP and UNIX Sockets are supported

                      ::: {.note}
                      If the postgresql server is on the same machine you can add an `after` to the quassel systemd service:
                      ```
                      systemd.services.quassel.after = [ "postgresql.service" ]
                      ```
                      :::
                    '';
                    default = {};
                    type = types.submodule {
                      options = {
                        username = mkOption {
                          type = types.str;
                          default = "quassel";
                          description = lib.mdDoc ''
                            Specifies the Postgres connection username.
                          '';
                        };

                        password = mkOption {
                          type = types.nullOr types.str;
                          default = null;
                          description = lib.mdDoc ''
                            Specifies the Postgres connection user password.
                            Can also be set as `DB_PGSQL_PASSWORD` in the `service.quassel.environmentFile`

                            Warning: do not set confidential information here because it
                            is world-readable in the Nix store.
                          '';
                        };

                        hostname = mkOption {
                          type = types.nullOr types.str;
                          default = "/var/run/postgresql/";
                          description = lib.mdDoc ''
                            Specifies the Postgres connection hostname.

                            Either an IP Address or hostname for a TCP Connection or the path to the directory
                            that contains a UNIX Socket.
                          '';
                        };

                        port = mkOption {
                          type = types.port;
                          default = 5432;
                          description = lib.mdDoc ''
                            Specifies the Postgres connection port.
                          '';
                        };

                        database = mkOption {
                          type = types.str;
                          default = "quassel";
                          description = lib.mdDoc ''
                            Specifies the Postgres connection database name.
                          '';
                        };
                      };
                    };
                  };
                };
              };
            };

            auth = mkOption {
              default = { };
              description = lib.mdDoc ''
                Configuration for quassel authentication backends
              '';
              type = types.submodule {
                options = {
                  authenticator = mkOption {
                    type = types.enum [ "Database" "LDAP" ];
                    default = "Database";
                    description = lib.mdDoc ''
                      Specify the backend used to authenticate users to quassel. Either "Database" to
                      use quassel database or "LDAP" to use an external LDAP Server
                    '';
                  };

                  ldap = mkOption {
                    description = lib.mdDoc ''
                      Configuration for quassel LDAP authentication backend

                      ::: {.note}
                      If the ldap server is on the same machine you can add an `after` to the quassel systemd service:
                      ```
                      systemd.services.quassel.after = [ "your-ldap-server.service" ]
                      ```
                      :::
                    '';
                    type = types.submodule {
                      options = {
                        hostname = mkOption {
                          type = types.str;
                          example = "ldap://example.com";
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator connection hostname.
                          '';
                        };

                        port = mkOption {
                          default = 389;
                          type = types.port;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator connection port.
                          '';
                        };

                        bindDN = mkOption {
                          type = types.str;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator bind DN.
                          '';
                        };

                        bindPassword = mkOption {
                          type = types.nullOr types.str;
                          default = null;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator bind password.
                            Can also be set as `AUTH_LDAP_BIND_PASSWORD` in the `service.quassel.environmentFile`

                            Warning: do not set confidential information here because it
                            is world-readable in the Nix store.
                          '';
                        };

                        baseDN = mkOption {
                          type = types.str;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator base DN.
                          '';
                        };

                        filter = mkOption {
                          type = types.str;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator filter.
                          '';
                          example = "(objectClass=inetOrgPerson)";
                        };

                        uidAttribute = mkOption {
                          default = "uid";
                          type = types.str;
                          description = lib.mdDoc ''
                            Specifies the LDAP authenticator UID attribute.
                          '';
                          example = "cn";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.ssl.required -> cfg.settings.ssl.certFile != null;
        message = "Quassel needs a certificate file in order to require SSL";
      }
    ];

    users.users = optionalAttrs (cfg.user == null) {
      quassel = {
        name = "quassel";
        description = "Quassel IRC client daemon";
        group = "quassel";
        uid = config.ids.uids.quassel;
      };
    };

    users.groups = optionalAttrs (cfg.user == null) {
      quassel = {
        name = "quassel";
        gid = config.ids.gids.quassel;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.settings.dataDir}' - ${user} - - -"
    ];

    systemd.services.quassel =
      {
        description = "Quassel IRC client daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig =
          {
            ExecStart = (concatStringsSep " " ([
              "${quassel}/bin/quasselcore"
              "--listen=${concatStringsSep "," cfg.settings.listen}"
              "--port=${toString cfg.settings.port}"
              "--configdir=${cfg.settings.dataDir}"
              "--loglevel=${cfg.settings.logLevel}"
            ]
            ++ (optionals cfg.settings.ident.enable
              [
                "--ident-daemon"
                "--ident-listen=${concatStringsSep "," cfg.settings.ident.listen}"
                "--ident-port=${toString cfg.settings.ident.port}"
              ] ++ (optional cfg.settings.ident.strict "--strict-ident"))
            ++ optionals cfg.settings.oidentd.enable [
              "--oidentd"
              "--oidentd-conffile=${cfg.settings.ident.listen}"
            ]
            ++ optionals cfg.settings.metrics.enable [
              "--metrics-daemon"
              "--metrics-listen=${concatStringsSep "," cfg.settings.metrics.listen}"
              "--metrics-port=${toString cfg.settings.metrics.port}"
            ]
            ++ optional cfg.settings.useDeclarativeConfig "--config-from-environment"

            # SSL
            ++ optional cfg.settings.ssl.required "--require-ssl"
            ++ optional (cfg.settings.ssl.certFile != null) "--ssl-cert=$CREDENTIALS_DIRECTORY/certfile"
            ++ optional (cfg.settings.ssl.keyFile != null) "--ssl-key=$CREDENTIALS_DIRECTORY/keyfile"
            ));

            LoadCredential =
              optional (cfg.settings.ssl.certFile != null) "certfile:${cfg.settings.ssl.certFile}"
              ++ optional (cfg.settings.ssl.keyFile != null) "keyfile:${cfg.settings.ssl.keyFile}";

            ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

            EnvironmentFile = mkIf
              (cfg.environmentFile != null) [ cfg.environmentFile ];
            Environment = mkIf cfg.settings.useDeclarativeConfig ([
              "AUTH_AUTHENTICATOR=${cfg.settings.auth.authenticator}"
              "DB_BACKEND=${cfg.settings.db.backend}"
            ] ++ (optional (cfg.settings.db.backend == "PostgreSQL") [
              "DB_PGSQL_DATABASE=${cfg.settings.db.pgsql.database}"
              "DB_PGSQL_HOSTNAME=${cfg.settings.db.pgsql.hostname}"
              "DB_PGSQL_USERNAME=${cfg.settings.db.pgsql.username}"
              "DB_PGSQL_PORT=${toString cfg.settings.db.pgsql.port}"
            ] ++ optional (cfg.settings.db.pgsql.password != null) "DB_PGSQL_PASSWORD=${cfg.settings.db.pgsql.password}"
            ) ++ (optional (cfg.settings.auth.authenticator == "LDAP") [
              "AUTH_LDAP_BASE_DN=${cfg.settings.auth.ldap.baseDN}"
              "AUTH_LDAP_BIND_DN=${cfg.settings.auth.ldap.bindDN}"
              "AUTH_LDAP_FILTER=${cfg.settings.auth.ldap.filter}"
              "AUTH_LDAP_HOSTNAME=${cfg.settings.auth.ldap.hostname}"
              "AUTH_LDAP_PORT=${toString cfg.settings.auth.ldap.port}"
              "AUTH_LDAP_UID_ATTRIBUTE=${cfg.settings.auth.ldap.uidAttribute}"
            ] ++ optional (cfg.settings.auth.ldap.bindPassword != null) "AUTH_LDAP_BIND_PASSWORD=${cfg.settings.auth.ldap.bindPassword}"
            ));
            User = user;
          };
      };
  };
}
