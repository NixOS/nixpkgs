import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    port = 6000;
  in
  {
    name = "gokapi";

    meta.maintainers = with lib.maintainers; [ delliott ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.gokapi = {
          enable = true;
          environment.GOKAPI_PORT = toString port;
        };
      };

    testScript = ''
      machine.wait_for_unit("gokapi.service")
      machine.wait_for_open_port(${toString port})
      machine.succeed("curl --fail http://localhost:${toString port}/")
    '';
  }
)
