import ./make-test-python.nix (
  let
    host = "127.0.0.1";
    port = 1234;
  in
  { lib, pkgs, ... }:
  {
    name = "stash";
    meta.maintainers = pkgs.stash.meta.maintainers;

    nodes.machine = {
      services.stash = {
        enable = true;
        inherit host port;
      };
    };

    testScript = ''
      machine.wait_for_unit("stash.service")
      machine.wait_for_open_port(${toString port}, "${host}")
      machine.succeed("curl --fail http://${host}:${toString port}/")
    '';
  }
)
