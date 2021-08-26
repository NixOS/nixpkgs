{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.plausible;

  # FIXME consider using LoadCredential as soon as it actually works.
  envSecrets = ''
    ADMIN_USER_PWD="$(<${cfg.adminUser.passwordFile})"
    export ADMIN_USER_PWD # separate export to make `set -e` work

    SECRET_KEY_BASE="$(<${cfg.server.secretKeybaseFile})"
    export SECRET_KEY_BASE # separate export to make `set -e` work

    ${optionalString (cfg.mail.smtp.passwordFile != null) ''
      SMTP_USER_PWD="$(<${cfg.mail.smtp.passwordFile})"
      export SMTP_USER_PWD # separate export to make `set -e` work
    ''}
  '';
in {
  options.services.plausible = {
    enable = mkEnableOption "plausible";

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
        setup = mkEnableOption "creating a clickhouse instance" // { default = true; };
        url = mkOption {
          default = "http://localhost:8123/default";
          type = types.str;
          description = ''
            The URL to be used to connect to <package>clickhouse</package>.
          '';
        };
      };
      postgres = {
        setup = mkEnableOption "creating a postgresql instance" // { default = true; };
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
            Path to the UNIX domain-socket to communicate with <package>postgres</package>.
          '';
        };
      };
    };

    server = {
      disableRegistration = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to prohibit creating an account in plausible's UI.
        '';
      };
      secretKeybaseFile = mkOption {
        type = types.either types.path types.str;
        description = ''
          Path to the secret used by the <literal>phoenix</literal>-framework. Instructions
          how to generate one are documented in the
          <link xlink:href="https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html#content">
          framework docs</link>.
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

          Note that <literal>/path</literal> components are currently ignored:
          <link xlink:href="https://github.com/plausible/analytics/issues/1182">
            https://github.com/plausible/analytics/issues/1182
          </link>.
        '';
      };
    };

    mail = {
      email = mkOption {
        default = "hello@plausible.local";
        type = types.str;
        description = ''
          The email id to use for as <emphasis>from</emphasis> address of all communications
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

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.adminUser.activate -> cfg.database.postgres.setup;
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

    systemd.services = mkMerge [
      {
        plausible = {
          inherit (pkgs.plausible.meta) description;
          documentation = [ "https://plausible.io/docs/self-hosting" ];
          wantedBy = [ "multi-user.target" ];
          after = optional cfg.database.postgres.setup "plausible-postgres.service";
          requires = optional cfg.database.clickhouse.setup "clickhouse.service"
            ++ optionals cfg.database.postgres.setup [
              "postgresql.service"
              "plausible-postgres.service"
            ];

          environment = {
            # NixOS specific option to avoid that it's trying to write into its store-path.
            # See also https://github.com/lau/tzdata#data-directory-and-releases
            TZDATA_DIR = "/var/lib/plausible/elixir_tzdata";

            # Configuration options from
            # https://plausible.io/docs/self-hosting-configuration
            PORT = toString cfg.server.port;
            DISABLE_REGISTRATION = boolToString cfg.server.disableRegistration;

            RELEASE_TMP = "/var/lib/plausible/tmp";

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
          } // (optionalAttrs (cfg.mail.smtp.user != null) {
            SMTP_USER_NAME = cfg.mail.smtp.user;
          });

          path = [ pkgs.plausible ]
            ++ optional cfg.database.postgres.setup config.services.postgresql.package;

          serviceConfig = {
            DynamicUser = true;
            PrivateTmp = true;
            WorkingDirectory = "/var/lib/plausible";
            StateDirectory = "plausible";
            ExecStartPre = "@${pkgs.writeShellScript "plausible-setup" ''
              set -eu -o pipefail
              ${envSecrets}
              ${pkgs.plausible}/createdb.sh
              ${pkgs.plausible}/migrate.sh
              ${optionalString cfg.adminUser.activate ''
                if ! ${pkgs.plausible}/init-admin.sh | grep 'already exists'; then
                  psql -d plausible <<< "UPDATE users SET email_verified=true;"
                fi
              ''}
            ''} plausible-setup";
            ExecStart = "@${pkgs.writeShellScript "plausible" ''
              set -eu -o pipefail
              ${envSecrets}
              plausible start
            ''} plausible";
          };
        };
      }
      (mkIf cfg.database.postgres.setup {
        # `plausible' requires the `citext'-extension.
        plausible-postgres = {
          after = [ "postgresql.service" ];
          bindsTo = [ "postgresql.service" ];
          requiredBy = [ "plausible.service" ];
          partOf = [ "plausible.service" ];
          serviceConfig.Type = "oneshot";
          unitConfig.ConditionPathExists = "!/var/lib/plausible/.db-setup";
          script = ''
            mkdir -p /var/lib/plausible/
            PSQL() {
              /run/wrappers/bin/sudo -Hu postgres ${config.services.postgresql.package}/bin/psql --port=5432 "$@"
            }
            PSQL -tAc "CREATE ROLE plausible WITH LOGIN;"
            PSQL -tAc "CREATE DATABASE plausible WITH OWNER plausible;"
            PSQL -d plausible -tAc "CREATE EXTENSION IF NOT EXISTS citext;"
            touch /var/lib/plausible/.db-setup
          '';
        };
      })
    ];
  };

  meta.maintainers = with maintainers; [ ma27 ];
  meta.doc = ./plausible.xml;
}
