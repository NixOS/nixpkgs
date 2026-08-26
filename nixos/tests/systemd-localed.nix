{ lib, ... }:
{
  name = "systemd-localed";
  meta.maintainers = [ lib.maintainers.haansn08 ];

  nodes.machine = { ... }: {
    # we don't use services.xserver.enable because some window managers like
    # niri rely on systemd-localed for the keyboard layout:
    # https://niri-wm.github.io/niri/Configuration%3A-Input.html#layout
    services.graphical-desktop.enable = true;

    services.xserver.xkb.layout = "jp";
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")
    machine.wait_for_unit("dbus.socket")

    status, stdout = machine.execute("localectl")
    t.assertIn("X11 Layout: jp", stdout)
  '';
}
