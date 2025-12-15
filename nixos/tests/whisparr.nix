{ lib, ... }:
{
  name = "whisparr";
  meta.maintainers = [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.whisparr.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("whisparr.service")
    machine.wait_for_open_port(6969)
    machine.succeed("curl --fail http://localhost:6969/")
  '';
}
