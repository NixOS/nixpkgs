{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.plausible;

in
{
  options.services.plausible = {
    enable = mkEnableOption "plausible";

    package = mkPackageOption pkgs "plausible" { };

    adminUser = {
      name = mkOption {
        default = "admin";
        type = types.str;
        description = ''
          Name of the admin user that plausible will created on initial startup.
        '';
      };

      email = mkOption {
        type = types.str;
        example = "admin@localhost";
        description = ''
          Email-address of the admin-user.
        '';
      };

      passwordFile = mkOption {
        type = types.either types.str types.path;
        description = ''
          Path to the file which contains the password of the admin user.
        '';
      };

      activate = mkEnableOption "activating the freshly created admin-user";
    };

    database = {
      clickhouse = {
        setup = mkEnableOption "creating a clickhouse instance" // {
          default = true;
        };
        url = mkOption {
          default = "http://localhost:8123/default";
          type = types.str;
          description = ''
            The URL to be used to connect to `clickhouse`.
          '';
        };
      };
      postgres = {
        setup = mkEnableOption "creating a postgresql instance" // {
          default = true;
        };
        dbname = mkOption {
          default = "plausible";
          type = types.str;
          description = ''
            Name of the database to use.
          '';
        };
        socket = mkOption {
          default = "/run/postgresql";
          type = types.str;
          description = ''
            Path to the UNIX domain-socket to communicate with `postgres`.
          '';
        };
      };
    };

    server = {
      disableRegistration = mkOption {
        default = true;
        type = types.enum [
          true
          false
          "invite_only"
        ];
        description = ''
          Whether to prohibit creating an account in plausible's UI or allow on `invite_only`.
        '';
      };
      secretKeybaseFile = mkOption {
        type = types.either types.path types.str;
        description = ''
          Path to the secret used by the `phoenix`-framework. Instructions
          how to generate one are documented in the
          [
          framework docs](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html#content).
        '';
      };
      listenAddress = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = ''
          The IP address on which the server is listening.
        '';
      };
      port = mkOption {
        default = 8000;
        type = types.port;
        description = ''
          Port where the service should be available.
        '';
      };
      baseUrl = mkOption {
        type = types.str;
        description = ''
          Public URL where plausible is available.

          Note that `/path` components are currently ignored:
          [
            https://github.com/plausible/analytics/issues/1182
          ](https://github.com/plausible/analytics/issues/1182).
        '';
      };
    };

    mail = {
      email = mkOption {
        default = "hello@plausible.local";
        type = types.str;
        description = ''
          The email id to use for as *from* address of all communications
          from Plausible.
        '';
      };
      smtp = {
        hostAddr = mkOption {
          default = "localhost";
          type = types.str;
          description = ''
            The host address of your smtp server.
          '';
        };
        hostPort = mkOption {
          default = 25;
          type = types.port;
          description = ''
            The port of your smtp server.
          '';
        };
        user = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = ''
            The username/email in case SMTP auth is enabled.
          '';
        };
        passwordFile = mkOption {
          default = null;
          type = with types; nullOr (either str path);
          description = ''
            The path to the file with the password in case SMTP auth is enabled.
          '';
        };
        enableSSL = mkEnableOption "SSL when connecting to the SMTP server";
        retries = mkOption {
          type = types.ints.unsigned;
          default = 2;
          description = ''
            Number of retries to make until mailer gives up.
          '';
        };
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "plausible" "releaseCookiePath" ]
      "Plausible uses no distributed Erlang features, so this option is no longer necessary and was removed"
    )
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.adminUser.activate -> cfg.database.postgres.setup;
        message = ''
          Unable to automatically activate the admin-user if no locally managed DB for
          postgres (`services.plausible.database.postgres.setup') is enabled!
        '';
      }
    ];

    services.postgresql = mkIf cfg.database.postgres.setup {
      enable = true;
    };

    services.clickhouse = mkIf cfg.database.clickhouse.setup {
      enable = true;
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services = mkMerge [
      {
        plausible = {
          inherit (cfg.package.meta) description;
          documentation = [ "https://plausible.io/docs/self-hosting" ];
          wantedBy = [ "multi-user.target" ];
          after =
            optional cfg.database.clickhouse.setup "clickhouse.service"
            ++ optionals cfg.database.postgres.setup [
              "postgresql.service"
              "plausible-postgres.service"
            ];
          requires =
            optional cfg.database.clickhouse.setup "clickhouse.service"
            ++ optionals cfg.database.postgres.setup [
              "postgresql.service"
              "plausible-postgres.service"
            ];

          environment =
            {
              # NixOS specific option to avoid that it's trying to write into its store-path.
              # See also https://github.com/lau/tzdata#data-directory-and-releases
              STORAGE_DIR = "/var/lib/plausible/elixir_tzdata";

              # Configuration options from
              # https://plausible.io/docs/self-hosting-configuration
              PORT = toString cfg.server.port;
              LISTEN_IP = cfg.server.listenAddress;

              # Note [plausible-needs-no-erlang-distributed-features]:
              # Plausible does not use, and does not plan to use, any of
              # Erlang's distributed features, see:
              #     https://github.com/plausible/analytics/pull/1190#issuecomment-1018820934
              # Thus, disable distribution for improved simplicity and security:
              #
              # When distribution is enabled,
              # Elixir spwans the Erlang VM, which will listen by default on all
              # interfaces for messages between Erlang nodes (capable of
              # remote code execution); it can be protected by a cookie; see
              # https://erlang.org/doc/reference_manual/distributed.html#security).
              #
              # It would be possible to restrict the interface to one of our choice
              # (e.g. localhost or a VPN IP) similar to how we do it with `listenAddress`
              # for the Plausible web server; if distribution is ever needed in the future,
              # https://github.com/NixOS/nixpkgs/pull/130297 shows how to do it.
              #
              # But since Plausible does not use this feature in any way,
              # we just disable it.
              RELEASE_DISTRIBUTION = "none";
              # Additional safeguard, in case `RELEASE_DISTRIBUTION=none` ever
              # stops disabling the start of EPMD.
              ERL_EPMD_ADDRESS = "127.0.0.1";

              DISABLE_REGISTRATION =
                if isBool cfg.server.disableRegistration then
                  boolToString cfg.server.disableRegistration
                else
                  cfg.server.disableRegistration;

              RELEASE_TMP = "/var/lib/plausible/tmp";
              # Home is needed to connect to the node with iex
              HOME = "/var/lib/plausible";

              ADMIN_USER_NAME = cfg.adminUser.name;
              ADMIN_USER_EMAIL = cfg.adminUser.email;

              DATABASE_SOCKET_DIR = cfg.database.postgres.socket;
              DATABASE_NAME = cfg.database.postgres.dbname;
              CLICKHOUSE_DATABASE_URL = cfg.database.clickhouse.url;

              BASE_URL = cfg.server.baseUrl;

              MAILER_EMAIL = cfg.mail.email;
              SMTP_HOST_ADDR = cfg.mail.smtp.hostAddr;
              SMTP_HOST_PORT = toString cfg.mail.smtp.hostPort;
              SMTP_RETRIES = toString cfg.mail.smtp.retries;
              SMTP_HOST_SSL_ENABLED = boolToString cfg.mail.smtp.enableSSL;

              SELFHOST = "true";
            }
            // (optionalAttrs (cfg.mail.smtp.user != null) {
              SMTP_USER_NAME = cfg.mail.smtp.user;
            });

          path = [ cfg.package ] ++ optional cfg.database.postgres.setup config.services.postgresql.package;
          script = ''
            # Elixir does not start up if `RELEASE_COOKIE` is not set,
            # even though we set `RELEASE_DISTRIBUTION=none` so the cookie should be unused.
            # Thus, make a random one, which should then be ignored.
            export RELEASE_COOKIE=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 20)
            export ADMIN_USER_PWD="$(< $CREDENTIALS_DIRECTORY/ADMIN_USER_PWD )"
            export SECRET_KEY_BASE="$(< $CREDENTIALS_DIRECTORY/SECRET_KEY_BASE )"

            ${lib.optionalString (
              cfg.mail.smtp.passwordFile != null
            ) ''export SMTP_USER_PWD="$(< $CREDENTIALS_DIRECTORY/SMTP_USER_PWD )"''}

            ${lib.optionalString cfg.database.postgres.setup ''
              # setup
              ${cfg.package}/createdb.sh
            ''}

            ${cfg.package}/migrate.sh
            export IP_GEOLOCATION_DB=${pkgs.dbip-country-lite}/share/dbip/dbip-country-lite.mmdb
            ${cfg.package}/bin/plausible eval "(Plausible.Release.prepare() ; Plausible.Auth.create_user(\"$ADMIN_USER_NAME\", \"$ADMIN_USER_EMAIL\", \"$ADMIN_USER_PWD\"))"
            ${optionalString cfg.adminUser.activate ''
              psql -d plausible <<< "UPDATE users SET email_verified=true where email = '$ADMIN_USER_EMAIL';"
            ''}

            exec plausible start
          '';

          serviceConfig = {
            DynamicUser = true;
            PrivateTmp = true;
            WorkingDirectory = "/var/lib/plausible";
            StateDirectory = "plausible";
            LoadCredential =
              [
                "ADMIN_USER_PWD:${cfg.adminUser.passwordFile}"
                "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
              ]
              ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [
                "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"
              ];
          };
        };
      }
      (mkIf cfg.database.postgres.setup {
        # `plausible' requires the `citext'-extension.
        plausible-postgres = {
          after = [ "postgresql.service" ];
          partOf = [ "plausible.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = config.services.postgresql.superUser;
            RemainAfterExit = true;
          };
          script = with cfg.database.postgres; ''
            PSQL() {
              ${config.services.postgresql.package}/bin/psql --port=5432 "$@"
            }
            # check if the database already exists
            if ! PSQL -lqt | ${pkgs.coreutils}/bin/cut -d \| -f 1 | ${pkgs.gnugrep}/bin/grep -qw ${dbname} ; then
              PSQL -tAc "CREATE ROLE plausible WITH LOGIN;"
              PSQL -tAc "CREATE DATABASE ${dbname} WITH OWNER plausible;"
              PSQL -d ${dbname} -tAc "CREATE EXTENSION IF NOT EXISTS citext;"
            fi
          '';
        };
      })
    ];
  };

  meta.maintainers = teams.cyberus.members;
  meta.doc = ./plausible.md;
}
