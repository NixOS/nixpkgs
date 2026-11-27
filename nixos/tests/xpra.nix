{ lib, pkgs, ... }:
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

    # The display manager passes its own --xvfb.  A server started without one
    # runs the Xorg command from the package's conf.d instead.
    machine.succeed("xpra start :1 --socket-dirs=/run/xpra --daemon=yes")
    machine.wait_until_succeeds("xpra version --socket-dirs=/run/xpra :1")
    xorg = machine.succeed("pgrep --list-full Xorg")
    t.assertIn("-config ${pkgs.xpra}/etc/xpra/xorg.conf", xorg)
  '';
}
