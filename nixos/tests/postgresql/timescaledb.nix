{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION timescaledb;
    CREATE EXTENSION timescaledb_toolkit;

    CREATE TABLE sth (
      time TIMESTAMPTZ NOT NULL,
      value DOUBLE PRECISION
    );

    SELECT create_hypertable('sth', 'time');

    INSERT INTO sth (time, value) VALUES
    ('2003-04-12 04:05:06 America/New_York', 1.0),
    ('2003-04-12 04:05:07 America/New_York', 2.0),
    ('2003-04-12 04:05:08 America/New_York', 3.0),
    ('2003-04-12 04:05:09 America/New_York', 4.0),
    ('2003-04-12 04:05:10 America/New_York', 5.0)
    ;

    WITH t AS (
      SELECT
        time_bucket('1 day'::interval, time) AS dt,
        stats_agg(value) AS stats
      FROM sth
      GROUP BY time_bucket('1 day'::interval, time)
    )
    SELECT
      average(stats)
    FROM t;

    SELECT * FROM sth;
  '';

  makeTestFor =
    package:
    makeTest {
      name = "timescaledb-${package.name}";
      meta = with lib.maintainers; {
        maintainers = [ typetetris ];
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
                timescaledb
                timescaledb_toolkit
              ];
            settings = {
              shared_preload_libraries = "timescaledb, timescaledb_toolkit";
            };
          };
        };

      testScript = ''
        def check_count(statement, lines):
            return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
                statement, lines
            )


        machine.start()
        machine.wait_for_unit("postgresql")

        with subtest("Postgresql with extensions timescaledb and timescaledb_toolkit is available just after unit start"):
            machine.succeed(
                "sudo -u postgres psql -f ${test-sql}"
            )

        machine.fail(check_count("SELECT * FROM sth;", 3))
        machine.succeed(check_count("SELECT * FROM sth;", 5))
        machine.fail(check_count("SELECT * FROM sth;", 4))

        machine.shutdown()
      '';
    };
in
# Not run by default, because this requires allowUnfree.
# To run these tests:
#   NIXPKGS_ALLOW_UNFREE=1 nix-build -A nixosTests.postgresql.timescaledb
lib.dontRecurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.timescaledb.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
