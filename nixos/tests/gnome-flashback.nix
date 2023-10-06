import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "gnome-flashback";
  meta.maintainers = lib.teams.gnome.members ++ [ lib.maintainers.chpatrick ];

  nodes.machine = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager = {
        gdm.enable = true;
        gdm.debug = true;
        autoLogin = {
          enable = true;
          user = user.name;
        };
      };

      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.desktopManager.gnome.debug = true;
      services.xserver.desktopManager.gnome.flashback.enableMetacity = true;
      services.xserver.displayManager.defaultSession = "gnome-flashback-metacity";
    };

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    uid = toString user.uid;
    xauthority = "/run/user/${uid}/gdm/Xauthority";
  in ''
      with subtest("Login to GNOME Flashback with GDM"):
          # wait_for_x() checks graphical-session.target, which is expected to be
          # inactive on gnome-flashback before #228946 (i.e. systemd managed
          # gnome-session) is done.
          # https://github.com/NixOS/nixpkgs/pull/208060
          #
          # Previously this was unconditionally touched by xsessionWrapper but was
          # changed in #233981 (we have GNOME-Flashback:GNOME in XDG_CURRENT_DESKTOP).
          # machine.wait_for_x()
          machine.wait_until_succeeds('journalctl -t gnome-session-binary --grep "Entering running state"')
          # Wait for alice to be logged in"
          machine.wait_for_unit("default.target", "${user.name}")
          machine.wait_for_file("${xauthority}")
          machine.succeed("xauth merge ${xauthority}")
          # Check that logging in has given the user ownership of devices
          assert "alice" in machine.succeed("getfacl -p /dev/snd/timer")

      with subtest("Wait for Metacity"):
          machine.wait_until_succeeds("pgrep metacity")

      with subtest("Regression test for #233920"):
          machine.wait_until_succeeds("pgrep -fa gnome-flashback-media-keys")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})
