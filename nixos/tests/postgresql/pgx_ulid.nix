{
  pkgs,
  makeTest,
}:
let
  inherit (pkgs) lib;

  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION ulid;

    CREATE TABLE items (
      id ulid NOT NULL DEFAULT gen_monotonic_ulid() PRIMARY KEY,
      created_at TIMESTAMP GENERATED ALWAYS AS (id::TIMESTAMP) STORED
    );

    INSERT INTO items (id) VALUES
      ('01JGSK6X4APE5X5629ESGJBBV8'), -- 2025-01-03T21:23:17.770Z
      ('01ARZ3NDEKTSV4RRFFQ69G5FAV'); -- 2016-07-30T23:54:10.259Z
  '';

  makeTestFor =
    package:
    makeTest {
      name = "pgx_ulid-${package.name}";
      meta = with lib.maintainers; {
        maintainers = [ myypo ];
      };

      nodes.machine =
        { ... }:
        {
          services.postgresql = {
            inherit package;
            enable = true;
            enableJIT = lib.hasInfix "-jit-" package.name;
            extensions =
              ps: with ps; [
                pgx_ulid
              ];
            settings.shared_preload_libraries = "pgx_ulid";
          };
        };

      testScript =
        { nodes, ... }:
        let
          inherit (nodes.machine.services.postgresql.package.pkgs) pgx_ulid;
        in
        ''
          def check_count(statement, lines):
              return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
                  statement, lines
              )

          machine.start()
          machine.wait_for_unit("postgresql")

          with subtest("Postgresql with extension ulid is available just after unit start"):
              machine.succeed(check_count("SELECT * FROM pg_available_extensions WHERE name = 'ulid' AND default_version = '${pgx_ulid.version}';", 1))

          machine.succeed("sudo -u postgres psql -f ${test-sql}")

          machine.succeed(check_count("SELECT gen_ulid();", 1))
          machine.succeed(check_count("SELECT gen_monotonic_ulid();", 1))

          with subtest("Can generate default ULIDs and query by ULID-derived timestamps"):
              machine.succeed("""
                sudo -u postgres \\
                  psql -c "SELECT id FROM items ORDER BY created_at DESC LIMIT 1;" \\
                    | grep "01JGSK6X4APE5X5629ESGJBBV8"
              """)
              machine.succeed("""
                sudo -u postgres \\
                  psql -c "INSERT INTO items DEFAULT VALUES;"
              """)
              machine.succeed("""
                sudo -u postgres \\
                  psql -c "SELECT id FROM items ORDER BY created_at ASC LIMIT 1;" \\
                    | grep "01ARZ3NDEKTSV4RRFFQ69G5FAV"
              """)

          machine.shutdown()
        '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.pgx_ulid.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
