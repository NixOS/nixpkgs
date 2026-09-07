{ lib, ... }:

{
  name = "fluidd";
  meta.maintainers = with lib.maintainers; [ vtuan10 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.fluidd = {
        enable = true;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSfL http://localhost/ | grep 'fluidd'")
  '';
}
