{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.plausible;

  seedAdminEnabled = cfg.adminUser.email != null;

  # Note [plausible-seed-admin-no-wizard-race]:
  # Plausible Community Edition shows an unauthenticated "first launch" setup
  # wizard to create the admin user whenever no user exists in the database
  # (`Plausible.Release.should_be_first_launch?` is
  # `not Repo.exists?(Plausible.Auth.User)`, and `PlausibleWeb.FirstLaunchPlug`
  # 302-redirects every page to `/register` while that is true). On an instance
  # reachable over the network this lets any stranger create the first admin
  # account.
  #
  # `DISABLE_REGISTRATION` does NOT gate this wizard (it must not, otherwise the
  # first user could never be created), so the only robust fix is to ensure a
  # user already exists before the web server accepts any connection.
  #
  # We therefore seed the admin user inside the service's main `script`, after
  # the DB migrations and strictly before `exec plausible start`. This
  # guarantees there is no time window in which the wizard is reachable. The
  # seed is idempotent (it only inserts when no user exists), so it is safe to
  # run on every (re)start.
  #
  # We insert the precomputed bcrypt `password_hash` directly rather than going
  # through `Plausible.Auth.User.new/1`, so the plaintext password never has to
  # be stored on disk. `email_verified` is set to `true` because self-hosted
  # Plausible does not require email verification by default.
  #
  # This Elixir script may need updating as newer Plausible versions get
  # released (e.g. if the `Plausible.Auth.User` schema changes). The NixOS VM
  # test `nixos/tests/plausible.nix` validates that the wizard is unreachable
  # once an admin user is configured.
  seedAdminScript = pkgs.writeText "plausible-seed-admin.exs" ''
    # This script runs via `plausible eval`, which evaluates it WITHOUT
    # starting the `:plausible` application or its Ecto repos. We therefore
    # start them ourselves before querying/inserting, mirroring the private
    # `Plausible.Release.prepare/0` (the same startup the release uses for its
    # `migrate`/`seed` commands): load the app, start the DB-related apps and
    # start each Ecto repo. Otherwise `Repo.exists?/1` raises
    # `could not lookup Ecto repo Plausible.Repo because it was not started`.
    :ok = Application.ensure_loaded(:plausible)
    Enum.each([:ssl, :postgrex, :ch, :ecto], &Application.ensure_all_started/1)
    Enum.each(Application.fetch_env!(:plausible, :ecto_repos), & &1.start_link(pool_size: 2))

    alias Plausible.Repo
    alias Plausible.Auth.User

    unless Repo.exists?(User) do
      email = System.fetch_env!("SEED_ADMIN_USER_EMAIL")
      name = System.fetch_env!("SEED_ADMIN_USER_NAME")
      password_hash = System.fetch_env!("SEED_ADMIN_USER_PASSWORD_HASH")

      %User{
        email: email,
        name: name,
        password_hash: password_hash,
        email_verified: true
      }
      |> Repo.insert!()

      IO.puts("plausible: seeded admin user #{email}")
    end
  '';

in
{
  options.services.plausible = {
    enable = mkEnableOption "plausible";

    package = mkPackageOption pkgs "plausible" { };

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

    adminUser = {
      email = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          Email address of an admin user to seed into the database before the
          Plausible web server starts accepting connections.

          Plausible Community Edition shows an unauthenticated "first launch"
          setup wizard whenever no user exists in the database, which redirects
          every page to `/register` and lets anyone reaching the instance over
          the network create the first admin account. Setting this option (and
          {option}`services.plausible.adminUser.passwordHashFile`) seeds an
          admin user before the port is opened, so the wizard is never reachable
          by strangers.

          When `null`, no user is seeded and Plausible's setup wizard is used as
          usual.

          Seeding is idempotent: if any user already exists, no user is created.
        '';
        example = "admin@example.org";
      };

      name = mkOption {
        default = "Admin";
        type = types.str;
        description = ''
          Display name of the seeded admin user (see
          {option}`services.plausible.adminUser.email`).
        '';
      };

      passwordHashFile = mkOption {
        default = null;
        type = with types; nullOr (either str path);
        description = ''
          Path to a file containing the bcrypt hash of the seeded admin user's
          password (see {option}`services.plausible.adminUser.email`).

          Using a hash file (rather than the plaintext password) means the
          plaintext never has to be stored on disk or in the Nix store. Generate
          a hash e.g. with `mkpasswd -m bcrypt` (the resulting `$2b$...` string).

          This file is read via systemd's `LoadCredential`, so it does not enter
          the Nix store.
        '';
        example = "/run/secrets/plausible-admin-password-hash";
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
          [framework docs](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html#content).
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
          <https://github.com/plausible/analytics/issues/1182>.
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
    (mkRemovedOptionModule
      [
        "services"
        "plausible"
        "adminUser"
        "passwordFile"
      ]
      "Use services.plausible.adminUser.passwordHashFile instead, which keeps the plaintext password out of the Nix store"
    )
    (mkRemovedOptionModule
      [
        "services"
        "plausible"
        "adminUser"
        "activate"
      ]
      "The seeded admin user is always created as email-verified; self-hosted Plausible does not require email verification"
    )
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = seedAdminEnabled -> (cfg.adminUser.passwordHashFile != null);
        message = "services.plausible.adminUser.passwordHashFile must be set when services.plausible.adminUser.email is set.";
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
              "postgresql.target"
              "plausible-postgres.service"
            ];
          requires =
            optional cfg.database.clickhouse.setup "clickhouse.service"
            ++ optionals cfg.database.postgres.setup [
              "postgresql.target"
              "plausible-postgres.service"
            ];

          environment = {
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
            # Elixir spawns the Erlang VM, which will listen by default on all
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

            DATABASE_URL = "postgresql:///${cfg.database.postgres.dbname}?host=${cfg.database.postgres.socket}";
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
            export SECRET_KEY_BASE="$(< $CREDENTIALS_DIRECTORY/SECRET_KEY_BASE )"

            ${lib.optionalString (
              cfg.mail.smtp.passwordFile != null
            ) ''export SMTP_USER_PWD="$(< $CREDENTIALS_DIRECTORY/SMTP_USER_PWD )"''}

            ${lib.optionalString cfg.database.postgres.setup ''
              # setup
              ${cfg.package}/createdb.sh
            ''}

            ${cfg.package}/migrate.sh

            ${lib.optionalString seedAdminEnabled ''
              # Seed the admin user before the web server starts, so the
              # unauthenticated "first launch" setup wizard is never reachable;
              # see note [plausible-seed-admin-no-wizard-race].
              export SEED_ADMIN_USER_EMAIL=${lib.escapeShellArg cfg.adminUser.email}
              export SEED_ADMIN_USER_NAME=${lib.escapeShellArg cfg.adminUser.name}
              SEED_ADMIN_USER_PASSWORD_HASH="$(< "$CREDENTIALS_DIRECTORY/ADMIN_USER_PASSWORD_HASH" )"
              export SEED_ADMIN_USER_PASSWORD_HASH
              plausible eval "$(< ${seedAdminScript} )"
            ''}

            export IP_GEOLOCATION_DB=${pkgs.dbip-country-lite}/share/dbip/dbip-country-lite.mmdb

            exec plausible start
          '';

          serviceConfig = {
            DynamicUser = true;
            PrivateTmp = true;
            WorkingDirectory = "/var/lib/plausible";
            StateDirectory = "plausible";
            LoadCredential = [
              "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
            ]
            ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [
              "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"
            ]
            ++ lib.optionals seedAdminEnabled [
              "ADMIN_USER_PASSWORD_HASH:${cfg.adminUser.passwordHashFile}"
            ];
          };
        };
      }
      (mkIf cfg.database.postgres.setup {
        # `plausible' requires the `citext'-extension.
        plausible-postgres = {
          after = [ "postgresql.target" ];
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

  meta.maintainers = [ ];
  meta.doc = ./plausible.md;
}
