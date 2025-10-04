{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  redmineTest =
    { name, type }:
    makeTest {
      name = "redmine-${name}";
      nodes.machine =
        { config, pkgs, ... }:
        {
          services.redmine = {
            enable = true;
            package = pkgs.redmine;
            database.type = type;
          };
        };

      testScript = ''
        start_all()
        machine.wait_for_unit("redmine.service")
        machine.wait_for_open_port(3000)
        machine.succeed("curl --fail http://localhost:3000/")
      '';
    }
    // {
      meta.maintainers = [ maintainers.aanderse ];
    };
in
{
  sqlite3 = redmineTest {
    name = "sqlite3";
    type = "sqlite3";
  };
  mysql = redmineTest {
    name = "mysql";
    type = "mysql2";
  };
  pgsql = redmineTest {
    name = "pgsql";
    type = "postgresql";
  };
}
