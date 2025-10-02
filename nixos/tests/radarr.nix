{ lib, ... }:

{
  name = "radarr";
  meta.maintainers = with lib.maintainers; [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.radarr.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("radarr.service")
    machine.wait_for_open_port(7878)
    machine.succeed("curl --fail http://localhost:7878/")
  '';
}
