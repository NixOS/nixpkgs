{ lib, ... }:

{
  name = "sonarr";
  meta.maintainers = with lib.maintainers; [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.sonarr.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("sonarr.service")
    machine.wait_for_open_port(8989)
    machine.succeed("curl --fail http://localhost:8989/")
  '';
}
