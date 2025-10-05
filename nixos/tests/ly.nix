{ lib, ... }:

let
  machineBase = {
    imports = [ ./common/user-account.nix ];
    services.displayManager.ly = {
      enable = true;
      settings = {
        load = false;
        save = false;
      };
    };
  };
in
{
  name = "ly";

  nodes.machine =
    { ... }:
    lib.attrsets.recursiveUpdate machineBase {
      services.displayManager.ly.x11Support = true;
      services.xserver.enable = true;
      services.displayManager.defaultSession = "none+icewm";
      services.xserver.windowManager.icewm.enable = true;
    };
  nodes.machineNoX11 =
    { ... }:
    lib.attrsets.recursiveUpdate machineBase {
      services.displayManager.ly.x11Support = false;
      services.displayManager.defaultSession = "sway";
      programs.sway.enable = true;
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      start_all()

      machine.wait_until_tty_matches("1", "password:")
      machine.send_key("ctrl-alt-f1")
      machine.sleep(1)
      machine.screenshot("ly")
      machine.send_chars("alice")
      machine.send_key("tab")
      machine.send_chars("${user.password}")
      machine.send_key("ret")
      machine.wait_for_file("/run/user/${toString user.uid}/lyxauth")
      machine.succeed("xauth merge /run/user/${toString user.uid}/lyxauth")
      machine.wait_for_window("^IceWM ")
      machine.screenshot("icewm")

      machineNoX11.wait_until_tty_matches("1", "password:")
      machineNoX11.send_key("ctrl-alt-f1")
      machineNoX11.sleep(1)
      machineNoX11.screenshot("ly-no-x11")
      machineNoX11.send_chars("alice")
      machineNoX11.send_key("tab")
      machineNoX11.send_chars("${user.password}")
      machineNoX11.send_key("ret")
      machineNoX11.wait_for_file("/run/user/${toString user.uid}/wayland-1")
      machineNoX11.wait_for_file("/run/user/${toString user.uid}/sway-ipc.*.sock")
      machineNoX11.sleep(5)
      machineNoX11.screenshot("sway")
    '';
}
