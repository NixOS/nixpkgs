import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "budgie";

  meta.maintainers = [ lib.maintainers.federicoschonborn ];

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

    services.xserver.desktopManager.budgie = {
      enable = true;
      extraPlugins = [
        pkgs.budgiePlugins.budgie-analogue-clock-applet
      ];
    };
  };

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      with subtest("Wait for login"):
          # wait_for_x() checks graphical-session.target, which is expected to be
          # inactive on Budgie before #228946 (i.e. systemd managed gnome-session) is
          # done on upstream.
          # https://github.com/BuddiesOfBudgie/budgie-desktop/blob/v10.7.2/src/session/budgie-desktop.in#L16
          #
          # Previously this was unconditionally touched by xsessionWrapper but was
          # changed in #233981 (we have Budgie:GNOME in XDG_CURRENT_DESKTOP).
          # machine.wait_for_x()
          machine.wait_until_succeeds('journalctl -t gnome-session-binary --grep "Entering running state"')
          machine.wait_for_file("${user.home}/.Xauthority")
          machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Budgie session components actually start"):
          machine.wait_until_succeeds("pgrep budgie-daemon")
          machine.wait_for_window("budgie-daemon")
          machine.wait_until_succeeds("pgrep budgie-panel")
          machine.wait_for_window("budgie-panel")
          # We don't check xwininfo for this one.
          # See https://github.com/NixOS/nixpkgs/pull/216737#discussion_r1155312754
          machine.wait_until_succeeds("pgrep budgie-wm")

      with subtest("Open MATE terminal"):
          machine.succeed("su - ${user.name} -c 'DISPLAY=:0 mate-terminal >&2 &'")
          machine.wait_for_window("Terminal")

      with subtest("Check if budgie-wm has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep budgie-wm")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})
