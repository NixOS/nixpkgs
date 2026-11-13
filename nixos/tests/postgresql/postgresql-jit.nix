{
  runTest,
  genTests,
  ...
}:

let
  makeTestFor =
    package:
    runTest (
      { lib, pkgs, ... }:
      {
        name = "postgresql-jit-${package.name}";
        meta.maintainers = with lib.maintainers; [ ma27 ];

        nodes.machine =
          { pkgs, ... }:
          {
            services.postgresql = {
              inherit package;
              enable = true;
              enableJIT = true;
              initialScript = pkgs.writeText "init.sql" ''
                create table demo (id int);
                insert into demo (id) select generate_series(1, 5);
              '';
            };
          };

        testScript = ''
          machine.start()
          machine.wait_for_unit("postgresql.target")

          with subtest("JIT is enabled"):
              machine.succeed("sudo -u postgres psql <<<'show jit;' | grep 'on'")

          with subtest("Test JIT works fine"):
              output = machine.succeed(
                  "cat ${pkgs.writeText "test.sql" ''
                    set jit_above_cost = 1;
                    EXPLAIN ANALYZE SELECT CONCAT('jit result = ', SUM(id)) FROM demo;
                    SELECT CONCAT('jit result = ', SUM(id)) from demo;
                  ''} | sudo -u postgres psql"
              )
              t.assertIn("JIT:", output)
              t.assertIn("jit result = 15", output)

          machine.shutdown()
        '';
      }
    );
in
genTests {
  inherit makeTestFor;
}
