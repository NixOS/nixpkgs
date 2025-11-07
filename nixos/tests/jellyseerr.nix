{ lib, ... }:
{
  name = "jellyseerr";
  meta.maintainers = with lib.maintainers; [ matteopacini ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.jellyseerr.enable = true;
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("jellyseerr.service")
    machine.wait_for_open_port(5055)
    machine.succeed("curl --fail http://localhost:5055/")
  '';
}
