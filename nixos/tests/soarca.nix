import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "soarca";
    meta.maintainers = with lib.maintainers; [ _13621 ];

    nodes.machine = {
      services.soarca = {
        package = pkgs.soarca;
        enable = true;
        settings.PORT = 8475;
      };
    };

    testScript = ''
      machine.wait_for_unit("soarca.service")
      machine.wait_for_open_port(8475)

      machine.succeed("curl --fail http://localhost:8475/status/ping | grep 'pong'")
    '';
  }
)
