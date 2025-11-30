{
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

      programs.thunar.plugins = [ pkgs.xfce.thunar-archive-plugin ];
      programs.ydotool.enable = true;
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
    in
    ''
      with subtest("Wait for login"):
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
        # Change back to /dev/snd/timer after systemd-258.1
        machine.succeed("getfacl -p /dev/dri/card0 | grep -q ${user.name}")

      with subtest("Check if Xfce components actually start"):
        machine.wait_for_window("xfce4-panel")
        machine.wait_for_window("Desktop")
        for i in ["xfwm4", "xfsettingsd", "xfdesktop", "xfce4-notifyd", "xfconfd"]:
          machine.wait_until_succeeds(f"pgrep {i}")
        machine.wait_until_succeeds("pgrep -xf xfce4-screensaver")

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

      with subtest("Lock the screen"):
        machine.succeed("su - ${user.name} -c '${bus} xflock4 >&2 &'")
        machine.wait_until_succeeds("su - ${user.name} -c '${bus} xfce4-screensaver-command -q' | grep 'The screensaver is active'")
        machine.sleep(5)
        machine.succeed("ydotool click 0xC0")
        machine.wait_for_text("${user.description}|Unlock")
        machine.screenshot("screensaver")
        machine.send_chars("${user.password}\n", delay=0.2)
        machine.wait_until_succeeds("su - ${user.name} -c '${bus} xfce4-screensaver-command -q' | grep 'The screensaver is inactive'")
        machine.sleep(2)

      with subtest("Open Thunar"):
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 thunar >&2 &'")
        machine.wait_for_window("Thunar")
        machine.wait_for_text('(Pictures|Public|Templates|Videos)')

      with subtest("Check if any coredumps are found"):
        machine.succeed("(coredumpctl --json=short 2>&1 || true) | grep 'No coredumps found'")
        machine.sleep(10)
        machine.screenshot("screen")
    '';
}
