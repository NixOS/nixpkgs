{ pkgs, lib, ... }:
{
  name = "gnome-flashback";
  meta.maintainers = lib.teams.gnome.members ++ [ lib.maintainers.chpatrick ];

  nodes.machine =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in

    {
      imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.displayManager.gdm = {
        enable = true;
        debug = true;
      };

      services.displayManager.autoLogin = {
        enable = true;
        user = user.name;
      };

      services.desktopManager.gnome.enable = true;
      services.desktopManager.gnome.debug = true;
      services.desktopManager.gnome.flashback.enableMetacity = true;
      services.displayManager.defaultSession = "gnome-flashback-metacity";
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      uid = toString user.uid;
      xauthority = "/run/user/${uid}/gdm/Xauthority";
    in
    ''
      with subtest("Login to GNOME Flashback with GDM"):
          machine.wait_for_x()
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
}
