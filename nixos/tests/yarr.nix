{ lib, pkgs, ... }:

{
  name = "yarr";
  meta.maintainers = with lib.maintainers; [ christoph-heiss ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.yarr.enable = true;
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("yarr.service")
    machine.wait_for_open_port(7070)
    machine.succeed("curl -sSf http://localhost:7070 | grep '<title>yarr!</title>'")
  '';
}
