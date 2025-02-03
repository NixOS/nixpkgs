import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "budgie";

  meta.maintainers = lib.teams.budgie.members;

  nodes.machine = { ... }: {
    imports = [
      ./common/user-account.nix
    ];

    services.xserver.enable = true;

    services.xserver.displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "alice";
      };
    };

    # We don't ship gnome-text-editor in Budgie module, we add this line mainly
    # to catch eval issues related to this option.
    environment.budgie.excludePackages = [ pkgs.gnome-text-editor ];

    services.xserver.desktopManager.budgie = {
      enable = true;
      extraPlugins = [
        pkgs.budgie-analogue-clock-applet
      ];
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      env = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus DISPLAY=:0";
      su = command: "su - ${user.name} -c '${env} ${command}'";
    in
    ''
      with subtest("Wait for login"):
          # wait_for_x() checks graphical-session.target, which is expected to be
          # inactive on Budgie before Budgie manages user session with systemd.
          # https://github.com/BuddiesOfBudgie/budgie-desktop/blob/39e9f0895c978f76/src/session/budgie-desktop.in#L16
          #
          # Previously this was unconditionally touched by xsessionWrapper but was
          # changed in #233981 (we have Budgie:GNOME in XDG_CURRENT_DESKTOP).
          # machine.wait_for_x()
          machine.wait_until_succeeds('journalctl -t budgie-session-binary --grep "Entering running state"')
          machine.wait_for_file("${user.home}/.Xauthority")
          machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Budgie session components actually start"):
          for i in ["budgie-daemon", "budgie-panel", "budgie-wm", "budgie-desktop-view", "gsd-media-keys"]:
              machine.wait_until_succeeds(f"pgrep -f {i}")
          # We don't check xwininfo for budgie-wm.
          # See https://github.com/NixOS/nixpkgs/pull/216737#discussion_r1155312754
          machine.wait_for_window("budgie-daemon")
          machine.wait_for_window("budgie-panel")

      with subtest("Check if various environment variables are set"):
          cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf /run/current-system/sw/bin/budgie-wm)/environ"
          machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'Budgie:GNOME'")
          machine.succeed(f"{cmd} | grep 'BUDGIE_PLUGIN_DATADIR' | grep '${pkgs.budgie-desktop-with-plugins.pname}'")

      with subtest("Open run dialog"):
          machine.send_key("alt-f2")
          machine.wait_for_window("budgie-run-dialog")
          machine.sleep(2)
          machine.screenshot("run_dialog")
          machine.send_key("esc")

      with subtest("Open Budgie Control Center"):
          machine.succeed("${su "budgie-control-center >&2 &"}")
          machine.wait_for_window("Budgie Control Center")

      with subtest("Lock the screen"):
          machine.succeed("${su "budgie-screensaver-command -l >&2 &"}")
          machine.wait_until_succeeds("${su "budgie-screensaver-command -q"} | grep 'The screensaver is active'")
          machine.sleep(2)
          machine.send_chars("${user.password}", delay=0.5)
          machine.screenshot("budgie_screensaver")
          machine.send_chars("\n")
          machine.wait_until_succeeds("${su "budgie-screensaver-command -q"} | grep 'The screensaver is inactive'")
          machine.sleep(2)

      with subtest("Open GNOME terminal"):
          machine.succeed("${su "gnome-terminal"}")
          machine.wait_for_window("${user.name}@machine: ~")

      with subtest("Check if Budgie has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep budgie")
          machine.sleep(10)
          machine.screenshot("screen")
    '';
})
