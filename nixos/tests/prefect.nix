{ lib, ... }:
let
  mainPort = 4200;
in
{
  name = "prefect";

  nodes = {
    # No `baseUrl`: the module has to stand up on its defaults alone. It used
    # to interpolate a null one into PREFECT_UI_API_URL and fail to evaluate.
    machine =
      { ... }:
      {
        services.prefect = {
          enable = true;
          workerPools.default.installPolicy = "never";
        };
      };

    postgres =
      { pkgs, ... }:
      {
        services.prefect = {
          enable = true;
          database = "postgres";
          databaseUser = "prefect";
          databasePasswordFile = "/etc/prefect-db-password";
        };

        environment.etc."prefect-db-password".text = ''
          PREFECT_SERVER_DATABASE_PASSWORD=hunter2
        '';

        services.postgresql = {
          enable = true;
          # Prefect owns the database, which since PostgreSQL 15 is also what
          # gets it CREATE on the public schema - `ensureDatabases` would leave
          # the database owned by postgres and prefect unable to migrate.
          initialScript = pkgs.writeText "prefect-init.sql" ''
            CREATE ROLE prefect LOGIN PASSWORD 'hunter2';
            CREATE DATABASE prefect OWNER prefect;
          '';
        };

        systemd.services.prefect-server.after = [ "postgresql.service" ];
      };
  };

  testScript = ''
    start_all()

    with subtest("server comes up on its default settings"):
        machine.wait_for_unit("prefect-server.service")
        machine.wait_for_open_port(${toString mainPort})
        machine.succeed("curl -sSf http://127.0.0.1:${toString mainPort}/api/health")

    with subtest("worker registers its pool against the local api"):
        machine.wait_for_unit("prefect-worker-default.service")
        machine.wait_until_succeeds(
            "curl -sSf http://127.0.0.1:${toString mainPort}/api/work_pools/default",
            timeout=60,
        )

    with subtest("server talks to postgres rather than falling back to sqlite"):
        postgres.wait_for_unit("postgresql.service")
        postgres.wait_for_unit("prefect-server.service")
        postgres.wait_for_open_port(${toString mainPort})
        postgres.succeed("curl -sSf http://127.0.0.1:${toString mainPort}/api/health")
        # the sqlite database would live here if the postgres settings were ignored
        postgres.fail("test -e /var/lib/prefect-server/prefect.db")
        postgres.succeed(
            "sudo -u postgres psql -d prefect -c '\\dt' | grep -q flow_run"
        )
  '';

  meta = {
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
