{ lib, ... }:

{
  name = "metube";
  meta.maintainers = with lib.maintainers; [ hunterwilkins2 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.metube.enable = true;
      services.metube.settings.DOWNLOAD_DIR = "/downloads";
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("metube.service")
    machine.wait_for_open_port(8081)
    machine.succeed("curl --fail http://localhost:8081/")
  '';
}
