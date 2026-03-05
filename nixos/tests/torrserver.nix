{ ... }:
{
  name = "torrserver";

  nodes.machine =
    { pkgs, ... }:
    {
      services.torrserver = {
        enable = true;
        port = 1441;
      };
    };

  testScript = ''
    machine.wait_for_unit("torrserver.service")
    machine.wait_for_open_port(1441)
  '';
}
