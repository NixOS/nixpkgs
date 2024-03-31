import ./make-test-python.nix ({ lib, ... }: {
  name = "linkding";
  meta.maintainers = with lib.maintainers; [ rogryza ];

  nodes = {
    sqlite = {
      services.linkding = {
        enable = true;
        virtualHost = "linkding";
      };
    };

    postgres = {
      services.linkding = {
        enable = true;
        virtualHost = "linkding";

        database.engine = "postgres";
      };

      services.postgresql = {
        ensureDatabases = [ "linkding" ];
        ensureUsers = [
          {
            name = "linkding";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };

  testScript = ''
    sqlite.wait_for_unit("linkding.socket")

    with subtest("Web interface gets ready"):
        sqlite.wait_for_open_port(80, timeout=30)
        sqlite.succeed("curl -fs http://localhost")
        sqlite.require_unit_state("linkding.service", "active")

    with subtest("Background tasks processor gets ready"):
        sqlite.wait_for_unit("linkding-background-tasks.service")

    with subtest("Management script succesfully creates superuser"):
        sqlite.execute("/var/lib/linkding/linkding-manage createsuperuser --noinput --username a --email a@example.com")

    with subtest("Postgres migration works"):
        postgres.wait_for_unit("linkding-migrate.service")
  '';
})
