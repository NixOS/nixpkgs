{ ... }:

let
  port = 3142;
  defaultPort = 8080;

  customUsername = "alice";
  customUsernameFile = "/run/secrets/miniflux/custom-username";
  customPassword = "correcthorsebatterystaple";
  customPasswordFile = "/run/secrets/miniflux/custom-password";
  defaultUsername = "admin";
  defaultUsernameFile = "/run/secrets/miniflux/default-username";
  defaultPassword = "password";
  defaultPasswordFile = "/run/secrets/miniflux/default-password";
  postgresPassword = "correcthorsebatterystaple";
  pgpassFile = "/run/secrets/psql/pgpass";
  secretsModule = {
    systemd.tmpfiles.settings.secrets = {
      ${defaultUsernameFile}.f.argument = defaultUsername;
      ${defaultPasswordFile}.f.argument = defaultPassword;
      ${customUsernameFile}.f.argument = customUsername;
      ${customPasswordFile}.f.argument = customPassword;
      ${pgpassFile}.f.argument = "*:*:*:*:${postgresPassword}";
    };
  };
in
{
  name = "miniflux";
  meta.maintainers = [ ];

  nodes = {
    default =
      { ... }:
      {
        imports = [ secretsModule ];
        security.apparmor.enable = true;
        services.miniflux = {
          enable = true;
          adminUsernameFile = defaultUsernameFile;
          adminPasswordFile = defaultPasswordFile;
        };
      };

    withoutSudo =
      { ... }:
      {
        imports = [ secretsModule ];
        security.apparmor.enable = true;
        services.miniflux = {
          enable = true;
          adminUsernameFile = defaultUsernameFile;
          adminPasswordFile = defaultPasswordFile;
        };
        security.sudo.enable = false;
      };

    customized =
      { ... }:
      {
        imports = [ secretsModule ];
        security.apparmor.enable = true;
        services.miniflux = {
          enable = true;
          config = {
            CLEANUP_FREQUENCY = "48";
            LISTEN_ADDR = "localhost:${toString port}";
          };
          adminUsernameFile = customUsernameFile;
          adminPasswordFile = customPasswordFile;
        };
      };

    postgresTcp =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.postgresql = {
          enable = true;
          initialScript = pkgs.writeText "init-postgres" ''
            CREATE USER miniflux WITH PASSWORD '${postgresPassword}';
            CREATE DATABASE miniflux WITH OWNER miniflux;
          '';
          enableTCPIP = true;
          authentication = ''
            host sameuser miniflux samenet scram-sha-256
          '';
        };
        systemd.services.postgresql-setup.postStart = lib.mkAfter ''
          psql -tAd miniflux -c 'CREATE EXTENSION hstore;'
        '';
        networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
      };
    externalDb =
      { ... }:
      {
        imports = [ secretsModule ];
        security.apparmor.enable = true;
        services.miniflux = {
          enable = true;
          createDatabaseLocally = false;
          adminUsernameFile = defaultUsernameFile;
          adminPasswordFile = defaultPasswordFile;
          pgpassFile = pgpassFile;
          config = {
            DATABASE_URL = "user=miniflux host=postgresTcp dbname=miniflux sslmode=disable";
          };
        };
      };
  };
  testScript = ''
    def runTest(machine, port, user):
      machine.wait_for_unit("miniflux.service")
      machine.wait_for_open_port(port)
      machine.succeed(f"curl --fail 'http://localhost:{port}/healthcheck' | grep OK")
      machine.succeed(
          f"curl 'http://localhost:{port}/v1/me' -u '{user}' -H Content-Type:application/json | grep '\"is_admin\":true'"
      )
      machine.fail('journalctl -b --no-pager --grep "^audit: .*apparmor=\\"DENIED\\""')

    default.start()
    withoutSudo.start()
    customized.start()
    postgresTcp.start()

    runTest(default, ${toString defaultPort}, "${defaultUsername}:${defaultPassword}")
    runTest(withoutSudo, ${toString defaultPort}, "${defaultUsername}:${defaultPassword}")
    runTest(customized, ${toString port}, "${customUsername}:${customPassword}")

    postgresTcp.wait_for_unit("postgresql.target")
    externalDb.start()
    runTest(externalDb, ${toString defaultPort}, "${defaultUsername}:${defaultPassword}")
  '';
}
