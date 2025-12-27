{ lib, ... }:
{
  name = "Shoko";

  nodes.machine = {
    services.shoko.enable = true;
  };

  nodes.machine2 =
    { pkgs, ... }:

    {
      services.shoko = {
        enable = true;
        plugins = [ pkgs.shokofin ];
      };
    };

  testScript = ''
    machine.wait_for_unit("shoko.service")
    machine.wait_for_open_port(8111)
    machine.succeed("curl --fail http://localhost:8111")

    machine2.wait_for_unit("shoko.service")
    machine2.wait_for_open_port(8111)
    machine2.succeed("curl --fail http://localhost:8111")
  '';

  meta.maintainers = with lib.maintainers; [
    diniamo
    nanoyaki
  ];
}
