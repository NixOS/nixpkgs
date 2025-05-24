{ lib, ... }:

{
  name = "rdt-client";
  meta.maintainers = with lib.maintainers; [ dmilligan ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.rdt-client = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("rdt-client.service")
    machine.wait_for_open_port(6500)
    machine.succeed("curl --fail http://localhost:6500/")
  '';
}
