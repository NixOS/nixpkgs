{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../../.. { inherit system config; } }:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  writefreelyTest = { name, type }:
    makeTest {
      name = "writefreely-${name}";

      nodes.machine = { config, pkgs, ... }: {
        services.writefreely = {
          enable = true;
          host = "localhost:3000";
          admin.name = "nixos";

          database = {
            inherit type;
            createLocally = type == "mysql";
            passwordFile = pkgs.writeText "db-pass" "pass";
          };

          settings.server.port = 3000;
        };
      };

      testScript = ''
        start_all()
        machine.wait_for_unit("writefreely.service")
        machine.wait_for_open_port(3000)
        machine.succeed("curl --fail http://localhost:3000")
      '';
    };
in {
  sqlite = writefreelyTest {
    name = "sqlite";
    type = "sqlite3";
  };
  mysql = writefreelyTest {
    name = "mysql";
    type = "mysql";
  };
}
