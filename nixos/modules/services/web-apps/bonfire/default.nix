{
  config,
  pkgs,
  lib,
  ...
}:
let
  service = "bonfire";
  cfg = config.services.${service};
  stateDir = "/var/lib/${service}";

  # Warning(-security/confidentiality):
  # even though secrets are read from files (encrypted or outside the Nix store),
  # they end up in environment variables.
  #
  # Issue: https://github.com/bonfire-networks/bonfire-app/issues/1663
  #
  # ToDo(+security/confidentiality): move entries from `secretsStillUnsafe` to `secrets`
  # whenever they can remain in a file instead of going into an env-var.
  secretsStillUnsafe = [
    "ENCRYPTION_SALT"
    "MEILI_MASTER_KEY"
    "POSTGRES_PASSWORD"
    "RELEASE_COOKIE"
    "SECRET_KEY_BASE"
    "SIGNING_SALT"
  ];
  secrets = [ ];

  elixirFormat = pkgs.formats.elixirConf { elixir = cfg.package.elixir; };
  inherit (elixirFormat.lib) mkRaw mkTuple;

in
{
  imports = [
    (lib.modules.importApply ./reverse-proxy.nix {
      inherit service;
      proxyPass = "http://localhost:${toString cfg.settings.SERVER_PORT}";
      proxyWebsockets = true;
    })
  ];

  options.services.bonfire = {
    enable = lib.mkEnableOption "bonfire";
    openFirewall = lib.mkEnableOption ''
      opening the firewall for Bonfire's PUBLIC_PORT.
      This is only necessary if you do not use a reverse-proxy
    '';
    package = lib.mkPackageOption pkgs [ "bonfire-social" ] { };
    settings = lib.mkOption {
      description = ''
        Configuration for Bonfire, will be passed as environment variables.
        See <https://docs.bonfirenetworks.org/deploy.html>.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            path
            port
            str
          ]);

        options = {
          DB_MIGRATE_INDEXES_CONCURRENTLY = lib.mkEnableOption ''
            disable changes to the database schema when upgrading Bonfire

            Bonfire initialization fails hard with concurrent indexing,
            yet it may be enabled after initial migrations were run
            if you feel lucky.
          '';
          DB_QUERIES_LOG_LEVEL = lib.mkOption {
            # Source: https://www.erlang.org/docs/26/apps/kernel/logger_chapter#log_level
            type = lib.types.enum [
              "emergency"
              "alert"
              "critical"
              "error"
              "warning"
              "notice"
              "info"
              "debug"
            ];
            description = "The log level.";
            default = "warning";
          };
          DISABLE_DB_AUTOMIGRATION = lib.mkEnableOption "disable changes to the database schema when upgrading Bonfire";
          ECTO_IPV6 =
            lib.mkEnableOption ''
              IPv6 when connecting to the PostgreSQL database.

              Do not enable it when connecting through a Unix socket,
              it would make it fail
            ''
            // {
              default = config.networking.enableIPv6 && !(lib.types.path.check cfg.settings.POSTGRES_HOST);
              defaultText = lib.literalExpression "config.networking.enableIPv6 && !(lib.types.path.check config.services.bonfire.settings.POSTGRES_HOST)";
            };
          ENCRYPTION_SALT = lib.mkOption {
            type = lib.types.str;
            description = ''
              The systemd credential name of the encryption salt,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>
            '';
            default = "${service}.ENCRYPTION_SALT";
          };
          FEDERATE =
            lib.mkEnableOption ''
              federate
            ''
            // {
              default = false;
            };
          HOSTNAME = lib.mkOption {
            type = lib.types.str;
            default = "${service}.${config.networking.domain}";
            defaultText = lib.literalExpression "bonfire-\${config.networking.domain}";
            description = ''
              Hostname your visitors will use to access bonfire.
            '';
          };
          LANG = lib.mkOption {
            type = lib.types.str;
            default = "en_US.UTF-8";
            description = "Default language and locale.";
          };
          LANGUAGE = lib.mkOption {
            type = lib.types.str;
            default = "en_US.UTF-8";
            description = "Default language and locale.";
          };
          MAIL_BACKEND = lib.mkOption {
            type = lib.types.enum [
              "smtp"
              "mailgun"
              "none"
            ];
            description = "The mail backend to use.";
            default = "none";
          };
          MEILI_MASTER_KEY = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              The systemd credential name of the Meilisearch master key,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>
            '';
            default = if cfg.meilisearch.enable then "${service}.MEILI_MASTER_KEY" else null;
            defaultText = lib.literalExpression ''
              if config.services.meilisearch.enable then "${service}.MEILI_MASTER_KEY" else null
            '';
          };
          PLUG_SERVER = lib.mkOption {
            type = lib.types.enum [
              "bandit"
              "cowboy"
            ];
            description = "Webserver to use.";
            default = "cowboy";
          };
          POSTGRES_HOST = lib.mkOption {
            type = lib.types.str;
            description = ''
              Hostname or Unix socket **directory** to connect to the PostgreSQL database.
            '';
            #default = "/run/postgresql";
            default = "localhost";
          };
          POSTGRES_DB = lib.mkOption {
            type = lib.types.str;
            description = "name of the PostgreSQL database";
            default = config.users.users.${service}.name;
            defaultText = lib.literalExpression "config.users.users.${service}.name";
          };
          POSTGRES_PASSWORD = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              The systemd credential name of the password to connect to the PostgreSQL database,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>
            '';
            default = "${service}.POSTGRES_PASSWORD";
          };
          POSTGRES_USER = lib.mkOption {
            type = lib.types.str;
            description = "role name to connect to the PostgreSQL database";
            default = config.users.users.${service}.name;
            defaultText = lib.literalExpression "config.users.users.${service}.name";
          };
          PUBLIC_PORT = lib.mkOption {
            type = lib.types.port;
            default = 4000;
            description = ''
              Port your visitors will use to access bonfire
              (typically 80 or 443 if using a reverse-proxy).
            '';
          };
          RELEASE_COOKIE = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              The systemd credential name of the Erlang Distribution cookie,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>

              It's recommend to use a long and randomly generated string such as:
              `head -c 40 /dev/random | base32`.
              It's also recommended to only use alphanumeric
              characters and underscores.

              All Bonfire components in your cluster must use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine.
              You do not need to set this except when you spread your cluster
              over multiple hosts.
            '';
            default = "${service}.RELEASE_COOKIE";
          };
          SEARCH_MEILI_INSTANCE = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              Hostname and port of Meilisearch search index.
            '';
            default = null;
          };
          SECRET_KEY_BASE = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              The systemd credential name of the key to sign/encrypt cookies and other secrets,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>

              It should be a unique base64 encoded secret.
              All Bonfire components in your cluster must use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine.
              You do not need to set this except when you spread your cluster
              over multiple hosts.
            '';
            default = "${service}.SECRET_KEY_BASE";
          };
          SIGNING_SALT = lib.mkOption {
            type = lib.types.str;
            description = ''
              The systemd credential name of the signing salt,
              resolved from systemd credential stores
              as documented at <https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ImportCredential=GLOB>
            '';
            default = "${service}.SIGNING_SALT";
          };
          SERVER_PORT = lib.mkOption {
            type = lib.types.port;
            default = 4000;
            description = "Bonfire port.";
          };
        };
      };
    };

    elixirSettings = lib.mkOption {
      description = ''
        Runtime Elixir configuration for Bonfire.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = elixirFormat.type;
        options = {
          ":bonfire" = {
            "Bonfire.Web.Endpoint" = {
              http = {
                ip = lib.mkOption {
                  description = "Listening IP address or Unix socket.";
                  default = mkTuple (lib.genList (_: 0) 8);
                  defaultText = lib.literalExpression ''
                    (pkgs.formats.elixirConf { }).lib.mkTuple [0 0 0 0 0 0 0 0]
                  '';
                  example = lib.literalExpression ''
                    (pkgs.formats.elixirConf { }).lib.mkTuple [0 0 0 0 0 0 0 0]
                  '';
                };
              };
            };
          };
          ":tzdata" = {
            ":data_dir" = lib.mkOption {
              internal = true;
              description = ''
                :tzdata needs a writable directory to auto-update
                its TimeZone data periodically.
              '';
              default = mkRaw ''"${stateDir}/tzdata"'';
            };
          };
        };
      };
    };

    meilisearch = {
      enable = lib.mkEnableOption "running a local Meilisearch search engine";
    };

    postgresql = {
      enable = lib.mkEnableOption "running a local PostgreSQL database";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        systemd.services.bonfire = {
          description = "Bonfire";
          after = [
            "network.target"
            "epmd.socket"
          ];
          wantedBy = [ "multi-user.target" ];
          environment =
            let
              envs =
                cfg.settings
                // {
                  DB_MIGRATE_INDEXES_CONCURRENTLY =
                    if cfg.settings.DB_MIGRATE_INDEXES_CONCURRENTLY then true else "false";
                  # Explanation: behaves like true even when set to false (default), because
                  # ecto_sparkles/lib/schema_migration/auto_migrator.ex
                  # checks only for the existence of this envvar, not its content.
                  DISABLE_DB_AUTOMIGRATION = if cfg.settings.DISABLE_DB_AUTOMIGRATION then true else null;
                }
                // {
                  # Explanation: bonfire_common/lib/runtime_config.ex tests only for the string "false".
                  # HowTo(maint/analyze): cat $(nix -L build --no-link --print-out-paths -f . \
                  #   projects.Bonfire.nixos.tests.basic.nodes.machine.systemd.services.bonfire.environment.BONFIRE_RUNTIME_CONFIG)
                  BONFIRE_RUNTIME_CONFIG = elixirFormat.generate "runtime.exs" cfg.elixirSettings;
                }
                // lib.optionalAttrs (lib.types.path.check cfg.settings.POSTGRES_HOST) {
                  # Explanation: using a Unix socket directly doesn't work without setting PGHOST too.
                  # Issue: https://github.com/elixir-ecto/postgrex/issues/415#issuecomment-2622198966
                  PGHOST = cfg.settings.POSTGRES_HOST;
                };
            in
            lib.pipe envs [
              (lib.filterAttrs (name: value: !lib.elem name (secretsStillUnsafe ++ secrets) && value != null))
              (lib.mapAttrs (
                name: value:
                # Explanation: convert to string only simple types
                # otherwise keep as is to preserve any string context.
                if lib.isBool value || lib.isInt value then toString value else value
              ))
            ]
            // lib.genAttrs (lib.filter (secret: cfg.settings.${secret} != null) secrets) (
              secret: "%d/${cfg.settings.${secret}}"
            );

          serviceConfig = {
            User = config.users.users.${service}.name;
            Group = config.users.groups.${service}.name;
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "${service}-ExecStart";
                text = ''
                  set -x
                ''
                +
                  # Description: load `secretsStillUnsafe` into env-vars
                  # from `bonfire.* credentials`.
                  lib.concatMapStringsSep "\n" (
                    secret:
                    lib.optionalString (cfg.settings.${secret} != null) ''
                      ${secret}=''$(systemd-creds cat ${lib.escapeShellArg cfg.settings.${secret}})
                      export ${secret}
                    ''
                  ) secretsStillUnsafe
                + ''
                  exec ${lib.getExe cfg.package} start
                '';
              }
            );
            ExecStop = "${lib.getExe cfg.package} stop";
            RuntimeDirectory = [ service ];
            StateDirectory = [ service ];
            # Explanation: make Bonfire puts data uploaded by its users in ${stateDir}/data/
            WorkingDirectory = stateDir;
            Restart = lib.mkDefault "on-failure";
            RestartSec = lib.mkDefault 10;
            ImportCredential = lib.concatMap (
              secret: if cfg.settings.${secret} == null then [ ] else [ cfg.settings.${secret} ]
            ) (secretsStillUnsafe ++ secrets);
          };
        };

        # Explanation: do not let ${service}.service be in charge of epmd.
        services.epmd = {
          enable = true;
        };

        users = {
          users.${service} = {
            description = "Bonfire";
            group = service;
            home = stateDir;
            isSystemUser = true;
          };
          groups.${service} = {
          };
        };

        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [ cfg.settings.PUBLIC_PORT ];
        };
      }

      (lib.mkIf cfg.postgresql.enable {
        systemd.services.${service} = {
          after = [ "postgresql.target" ];
          requires = [ "postgresql.target" ];
        };
        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          ensureDatabases = [ cfg.settings.POSTGRES_DB ];
          extensions = lib.mkIf (cfg.package.passthru.mixNixDeps ? "geo_postgis") (
            with config.services.postgresql.package.pkgs; [ postgis ]
          );
          ensureUsers = [
            {
              name = cfg.settings.POSTGRES_USER;
              ensureDBOwnership = true;
              ensureClauses.login = true;
            }
          ];
        };
        systemd.services.postgresql-setup = lib.mkIf (!(lib.types.path.check cfg.settings.POSTGRES_HOST)) {
          path = [
            config.services.postgresql.package
            pkgs.gnused
            pkgs.replace-secret
          ];
          postStart =
            let
              run = "/run/postgresql";
            in
            ''
              set -x
              install -m600 ${pkgs.writeText "" ''
                ALTER ROLE ${config.users.users.${service}.name} WITH ENCRYPTED PASSWORD '@DB_USER_PASSWORD@';
              ''} ${run}/init.sql
              replace-secret @DB_USER_PASSWORD@ $CREDENTIALS_DIRECTORY/${service}.POSTGRES_PASSWORD ${run}/init.sql
              psql -U postgres --file ${run}/init.sql
              rm ${run}/init.sql
            '';
          serviceConfig = {
            ImportCredential = "${service}.POSTGRES_PASSWORD";
          };
        };
      })

      (lib.mkIf cfg.nginx.enable {
        services.${service} = {
          settings = {
            HOSTNAME = lib.mkDefault cfg.nginx.serverName;
            PUBLIC_PORT = lib.mkDefault 443;
          };
          elixirSettings = {
            /*
                FixMe(+optimize +security +co-existence):
                Bonfire does not yet support Unix socket
                Issue: https://github.com/bonfire-networks/bonfire-app/issues/1698

                ":bonfire"."Bonfire.Web.Endpoint"."http" = {
                  "ip" = lib.mkDefault (mkTuple [
                    (mkAtom ":local")
                    "/run/bonfire/socket"
                  ]);
                  # Explanation: avoid crash:
                  # ** (EXIT) shutdown: failed to start child: :ranch_acceptors_sup
                  # ** (EXIT) :badarg
                  "port" = lib.mkDefault 0;
                  "transport_options" = {
                    # Explanation: config/runtime.exs sets :inet6 which is not compatible with a Unix socket
                    "socket_opts" = lib.mkDefault [ ];
                    # Explanation: let the group access the socket.
                    post_listen_callback = lib.mkDefault (
                      # mkRaw "fn (:local, sock) -> File.chmod!(sock, 0o660) end"
                      mkRaw ''fn _ -> File.chmod!("/run/bonfire/socket", 0o660) end''
                    );
                  };
                };
            */
          };
        };
      })

      (lib.mkIf cfg.meilisearch.enable {
        services.meilisearch = {
          enable = true;
        };
        systemd.services.${service}.serviceConfig = {
          LoadCredential = [ "${service}.MEILI_MASTER_KEY:${config.services.meilisearch.masterKeyFile}" ];
        };
        services.${service}.settings = {
          SEARCH_MEILI_INSTANCE = "http://${config.services.meilisearch.listenAddress}:${toString config.services.meilisearch.listenPort}";
        };
      })
    ]
  );

  meta = {
    maintainers = lib.teams.ngi.members;
  };
}
