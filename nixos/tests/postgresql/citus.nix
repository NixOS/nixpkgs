{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION citus;

    CREATE TABLE examples (
      id bigserial,
      shard_key int,
      PRIMARY KEY (id, shard_key)
    );

    SELECT create_distributed_table('examples', 'shard_key');

    INSERT INTO examples (shard_key) SELECT shard % 10 FROM generate_series(1,1000) shard;
  '';

  makeTestFor =
    package:
    makeTest {
      name = "citus-${package.name}";
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
                citus
              ];
            settings = {
              shared_preload_libraries = "citus";
            };
          };
        };

      testScript = ''
        def check_count(statement, lines):
            return 'test $(sudo -u postgres psql postgres -tAc "{}") -eq {}'.format(
                statement, lines
            )


        machine.start()
        machine.wait_for_unit("postgresql")

        with subtest("Postgresql with extension citus is available just after unit start"):
            machine.succeed(
                "sudo -u postgres psql -f ${test-sql}"
            )

        machine.succeed(check_count("SELECT count(*) FROM examples;", 1000))

        machine.shutdown()
      '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.citus.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
