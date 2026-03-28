{ lib, ... }:
{
  name = "pcp";
  # meta.maintainers = with lib.maintainers; [ randomizedcoder ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.pcp = {
        enable = true;
        preset = "custom";
        pmlogger.enable = false;
        pmie.enable = false;
        pmproxy.enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("pmcd.service")
    machine.wait_for_unit("pmproxy.service")
    machine.wait_for_open_port(44321)
    machine.wait_for_open_port(44322)
    machine.succeed("pminfo -f kernel.all.load")
    machine.succeed("pminfo -h localhost kernel.all.cpu.user")
  '';
}
