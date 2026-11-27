{ lib, ... }:
{
  name = "xpra";
  meta.maintainers = with lib.maintainers; [ aforemny ];

  nodes.machine = {
    services.xserver.enable = true;
    services.xserver.displayManager.xpra.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("display-manager.service")
    # The unit is active as soon as xpra starts; the TCP listener comes up
    # just before "xpra is ready".
    machine.wait_for_open_port(10000)
    machine.succeed("xpra version --socket-dirs=/run/xpra :0")
  '';
}
