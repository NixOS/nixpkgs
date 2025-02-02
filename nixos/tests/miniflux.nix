import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    port = 3142;
    username = "alice";
    password = "correcthorsebatterystaple";
    defaultPort = 8080;
    defaultUsername = "admin";
    defaultPassword = "password";
    adminCredentialsFile = pkgs.writeText "admin-credentials" ''
      ADMIN_USERNAME=${defaultUsername}
      ADMIN_PASSWORD=${defaultPassword}
    '';
    customAdminCredentialsFile = pkgs.writeText "admin-credentials" ''
      ADMIN_USERNAME=${username}
      ADMIN_PASSWORD=${password}
    '';
    postgresPassword = "correcthorsebatterystaple";
    postgresPasswordFile = pkgs.writeText "pgpass" ''
      *:*:*:*:${postgresPassword}
    '';

  in
  {
    name = "miniflux";
    meta.maintainers = [ ];

    nodes = {
      default =
        { ... }:
        {
          security.apparmor.enable = true;
          services.miniflux = {
            enable = true;
            inherit adminCredentialsFile;
          };
        };

      withoutSudo =
        { ... }:
        {
          security.apparmor.enable = true;
          services.miniflux = {
            enable = true;
            inherit adminCredentialsFile;
          };
          security.sudo.enable = false;
        };

      customized =
        { ... }:
        {
          security.apparmor.enable = true;
          services.miniflux = {
            enable = true;
            config = {
              CLEANUP_FREQUENCY = "48";
              LISTEN_ADDR = "localhost:${toString port}";
            };
            adminCredentialsFile = customAdminCredentialsFile;
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
          systemd.services.postgresql.postStart = lib.mkAfter ''
            $PSQL -tAd miniflux -c 'CREATE EXTENSION hstore;'
          '';
          networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
        };
      externalDb =
        { ... }:
        {
          security.apparmor.enable = true;
          services.miniflux = {
            enable = true;
            createDatabaseLocally = false;
            inherit adminCredentialsFile;
            config = {
              DATABASE_URL = "user=miniflux host=postgresTcp dbname=miniflux sslmode=disable";
              PGPASSFILE = "/run/miniflux/pgpass";
            };
          };
          systemd.services.miniflux.preStart = ''
            cp ${postgresPasswordFile} /run/miniflux/pgpass
            chmod 600 /run/miniflux/pgpass
          '';
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
      runTest(customized, ${toString port}, "${username}:${password}")

      postgresTcp.wait_for_unit("postgresql.service")
      externalDb.start()
      runTest(externalDb, ${toString defaultPort}, "${defaultUsername}:${defaultPassword}")
    '';
  }
)
