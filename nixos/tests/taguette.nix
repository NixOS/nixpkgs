{ lib, ... }:
let
  mainPort = 8080;
in
{
  name = "taguette";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.taguette = {
          enable = true;
          port = mainPort;
          adminPasswordFile = pkgs.writeText "admin_password.txt" ''
            admin
          '';
        };
      };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("taguette.service")
    machine.wait_for_open_port(${builtins.toString mainPort})

    machine.succeed("curl http://127.0.0.1:${builtins.toString mainPort}")
  '';

  meta = {
    maintainers = with lib.maintainers; [ drupol ];
  };
}
