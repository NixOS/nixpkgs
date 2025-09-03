{ pkgs, lib, ... }:
{
  name = "phylactery";

  nodes.machine =
    { ... }:
    {
      services.phylactery = rec {
        enable = true;
        port = 8080;
        library = "/tmp";
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit('phylactery')
    machine.wait_for_open_port(8080)
    machine.wait_until_succeeds('curl localhost:8080')
  '';

  meta.maintainers = with lib.maintainers; [ McSinyx ];
}
