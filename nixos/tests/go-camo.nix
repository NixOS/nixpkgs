{ system ? builtins.currentSystem, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing-python.nix { inherit system pkgs; };

{
  gocamo_file_key = let
      key_val = "12345678";
    in
    makeTest {
    name = "go-camo-file-key";
    meta = {
      maintainers = [ pkgs.lib.maintainers.viraptor ];
    };

    nodes.machine = { config, pkgs, ... }: {
      services.go-camo = {
        enable = true;
        keyFile = pkgs.writeText "foo" key_val;
      };
    };

    # go-camo responds to http requests
    testScript = ''
      machine.wait_for_unit("go-camo.service")
      machine.wait_for_open_port(8080)
      machine.succeed("curl http://localhost:8080")
    '';
  };
}
