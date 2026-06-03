{ lib, ... }:
{
  name = "seerr";
  meta.maintainers = with lib.maintainers; [
    matteopacini
    fallenbagel
  ];

  nodes = {
    machine =
      { ... }:
      {
        services.seerr.enable = true;
      };

    postgres =
      { ... }:
      {
        services.seerr = {
          enable = true;
          database = {
            type = "postgres";
            createLocally = true;
          };
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("default sqlite backend serves the web UI"):
        machine.wait_for_unit("seerr.service")
        machine.wait_for_open_port(5055)
        machine.succeed("curl --fail http://localhost:5055/")

    with subtest("postgres backend serves the web UI and creates its schema"):
        postgres.wait_for_unit("postgresql.service")
        # Seerr runs its TypeORM migrations against PostgreSQL on startup; the
        # unit only reaches "started" and opens its port once that succeeds.
        postgres.wait_for_unit("seerr.service")
        postgres.wait_for_open_port(5055)
        postgres.succeed("curl --fail http://localhost:5055/")
        # Prove the data really landed in PostgreSQL rather than a sqlite file.
        postgres.succeed(
            "test \"$(sudo -u postgres psql -tAc "
            "\"select count(*) from information_schema.tables where table_schema = 'public'\" seerr)\" -gt 0"
        )
  '';
}
