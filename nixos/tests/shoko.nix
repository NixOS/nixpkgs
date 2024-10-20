{ lib, ... }:
{
  name = "Shoko";

  nodes.machine = {
    services.shoko.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("shoko.service")
    machine.wait_for_open_port(8111)
    machine.succeed("curl --fail http://localhost:8111")
  '';

  meta.maintainers = [ lib.maintainers.diniamo ];
}
