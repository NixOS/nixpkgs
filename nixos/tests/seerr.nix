{ lib, ... }:
{
  name = "seerr";
  meta.maintainers = with lib.maintainers; [ matteopacini ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.seerr.enable = true;
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("seerr.service")
    machine.wait_for_open_port(5055)
    machine.succeed("curl --fail http://localhost:5055/")
  '';
}
