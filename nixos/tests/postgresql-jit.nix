{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, package ? null
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (pkgs) lib;
  packages = builtins.attrNames (import ../../pkgs/servers/sql/postgresql pkgs);

  mkJitTestFromName = name:
    mkJitTest pkgs.${name};

  mkJitTest = package: makeTest {
    name = package.name;
    meta.maintainers = with lib.maintainers; [ ma27 ];
    nodes.machine = { pkgs, lib, ... }: {
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
      machine.wait_for_unit("postgresql.service")

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
          assert "JIT:" in output
          assert "jit result = 15" in output

      machine.shutdown()
    '';
  };
in
if package == null then
  lib.genAttrs packages mkJitTestFromName
else
  mkJitTest package
