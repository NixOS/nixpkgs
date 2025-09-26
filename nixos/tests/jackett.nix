{ lib, ... }:

let
  jackettPort = 9117;
in
{
  name = "jackett";
  meta.maintainers = with lib.maintainers; [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.jackett.enable = true;
      services.jackett.port = jackettPort;
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("jackett.service")
    machine.wait_for_open_port(${toString jackettPort})
    machine.succeed("curl --fail http://localhost:${toString jackettPort}/")
  '';
}
