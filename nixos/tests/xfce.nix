import ./make-test-python.nix ({ pkgs, ...} : {
  name = "xfce";

  nodes.machine =
    { pkgs, ... }:

    {
      imports = [
        ./common/user-account.nix
      ];

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };

      services.xserver.desktopManager.xfce.enable = true;
      environment.systemPackages = [ pkgs.xfce.xfce4-whiskermenu-plugin ];
    };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
  in ''
      with subtest("Wait for login"):
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Xfce components actually start"):
        machine.wait_for_window("xfce4-panel")
        machine.wait_for_window("Desktop")
        for i in ["xfwm4", "xfsettingsd", "xfdesktop", "xfce4-screensaver", "xfce4-notifyd", "xfconfd"]:
          machine.wait_until_succeeds(f"pgrep -f {i}")

      with subtest("Open whiskermenu"):
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 ${bus} xfconf-query -c xfce4-panel -p /plugins/plugin-1 -t string -s whiskermenu -n >&2 &'")
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 ${bus} xfconf-query -c xfce4-panel -p /plugins/plugin-1/stay-on-focus-out -t bool -s true -n >&2 &'")
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 ${bus} xfce4-panel -r >&2 &'")
        machine.wait_until_succeeds("journalctl -b --grep 'xfce4-panel: Restarting' -t xsession")
        machine.sleep(5)
        machine.wait_until_succeeds("pgrep -f libwhiskermenu")
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 ${bus} xfce4-popup-whiskermenu >&2 &'")
        machine.wait_for_text('Mail Reader')
        # Close the menu.
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 ${bus} xfce4-popup-whiskermenu >&2 &'")

      with subtest("Open Xfce terminal"):
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 xfce4-terminal >&2 &'")
        machine.wait_for_window("Terminal")

      with subtest("Open Thunar"):
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 thunar >&2 &'")
        machine.wait_for_window("Thunar")
        machine.wait_for_text('(Pictures|Public|Templates|Videos)')

      with subtest("Check if any coredumps are found"):
        machine.succeed("(coredumpctl --json=short 2>&1 || true) | grep 'No coredumps found'")
        machine.sleep(10)
        machine.screenshot("screen")
    '';
})
