# This test does a basic functionality check for homebox

{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; config = { }; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
in
makeTest {
  name = "homebox";
  nodes = {
    host1 = {
      services.homebox = {
        enable = true;
        environment = {
          HBOX_STORAGE_DATA = "/var/lib/homebox";
          HBOX_STORAGE_SQLITE_URL = "/var/lib/homebox/homebox.db?_fk=1";
        };
      };
    };
  };

  testScript = ''
    start_all()

    host1.wait_for_unit("homebox.service")
    host1.wait_for_open_port(7745)
    host1.succeed("curl http://localhost:7745 | grep 'Track, Organize, and Manage your Things.'")
  '';
}

