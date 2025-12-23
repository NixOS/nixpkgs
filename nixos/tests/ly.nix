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
    # python
    ''
      from test_driver.errors import RequestedAssertionFailed
      start_all()

      # old ly versions before 1.1.2 used to allow typing the username
      # but now a user can only be selected from a set of users
      def navigate_user(machine, username, wm, tty="1"):
          wm = wm.lower()
          tries = 0
          while username not in machine.get_tty_text(tty):
              machine.send_key("left")
              machine.sleep(0.3)
              if tries > 3:
                  RequestedAssertionFailed(f"Failed to find user:{username} in ly")
              tries += 1

          # move cursor to wm selection
          machine.send_key("up")

          tries = 0
          while wm not in machine.get_tty_text(tty).lower():
              machine.send_key("left")
              machine.sleep(0.3)
              if tries > 3:
                  RequestedAssertionFailed(f"Failed to find wm:{wm} in ly")
              tries += 1

          # reset cursor to user selection
          machine.send_key("tab")

      # https://github.com/NixOS/nixpkgs/pull/455191#discussion_r2507716719
      machine.wait_until_succeeds("getfacl /dev/dri/card0 | grep video")
      machine.wait_until_tty_matches("1", "password")
      machine.send_key("ctrl-alt-f1")
      machine.sleep(1)
      machine.screenshot("ly")
      navigate_user(machine, "${user.name}", "icewm")
      machine.send_key("tab")
      machine.send_chars("${user.password}")
      machine.send_key("ret")
      machine.wait_for_file("/run/user/${toString user.uid}/lyxauth")
      machine.succeed("xauth merge /run/user/${toString user.uid}/lyxauth")
      machine.wait_for_window("^IceWM ")
      machine.sleep(2)
      machine.screenshot("icewm")

      machineNoX11.wait_until_tty_matches("1", "password")
      machineNoX11.send_key("ctrl-alt-f1")
      machineNoX11.sleep(1)
      machineNoX11.screenshot("ly-no-x11")
      navigate_user(machineNoX11, "${user.name}", "Sway")
      machineNoX11.send_key("tab")
      machineNoX11.send_chars("${user.password}")
      machineNoX11.send_key("ret")
      machineNoX11.wait_for_file("/run/user/${toString user.uid}/wayland-1")
      machineNoX11.wait_for_file("/run/user/${toString user.uid}/sway-ipc.*.sock")
      machineNoX11.sleep(5)
      machineNoX11.screenshot("sway")
    '';
}
