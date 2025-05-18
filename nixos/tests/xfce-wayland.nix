{
  name = "xfce-wayland";

  nodes.machine =
    { pkgs, ... }:

    {
      imports = [
        ./common/user-account.nix
      ];

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.displayManager = {
        defaultSession = "xfce-wayland";
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };

      services.xserver.desktopManager.xfce.enable = true;
      services.xserver.desktopManager.xfce.enableWaylandSession = true;
      environment.systemPackages = [ pkgs.wlrctl ];
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      rtdir = "XDG_RUNTIME_DIR=/run/user/${toString user.uid}";
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Wait for Wayland server"):
        machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")

      with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Xfce components actually start"):
        for p in ["labwc", "xfdesktop", "xfce4-notifyd", "xfconfd", "xfce4-panel"]:
          machine.wait_until_succeeds(f"pgrep {p}")

      with subtest("Open Xfce terminal"):
        machine.succeed("su - ${user.name} -c '${rtdir} xfce4-terminal >&2 &'")
        machine.wait_until_succeeds("su - ${user.name} -c '${rtdir} wlrctl toplevel list | grep xfce4-terminal'")

      with subtest("Open Thunar"):
        machine.succeed("su - ${user.name} -c '${rtdir} thunar >&2 &'")
        machine.wait_until_succeeds("su - ${user.name} -c '${rtdir} wlrctl toplevel list | grep Thunar'")
        machine.wait_for_text('(Pictures|Public|Templates|Videos)')

      with subtest("Check if various environment variables are set"):
        cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf xfce4-panel)/environ"
        machine.succeed(f"{cmd} | grep 'XDG_SESSION_TYPE' | grep 'wayland'")
        machine.succeed(f"{cmd} | grep 'XFCE4_SESSION_COMPOSITOR' | grep 'labwc'")
        machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'XFCE'")

      with subtest("Check if any coredumps are found"):
        machine.succeed("(coredumpctl --json=short 2>&1 || true) | grep 'No coredumps found'")
        machine.sleep(10)
        machine.screenshot("screen")
    '';
}
