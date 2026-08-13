{ pkgs, lib, ... }:
{
  name = "budgie";

  meta.maintainers = lib.teams.budgie.members;

  nodes.machine =
    { ... }:
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

      # We don't ship gnome-text-editor in Budgie module, we add this line mainly
      # to catch eval issues related to this option.
      environment.budgie.excludePackages = [ pkgs.gnome-text-editor ];

      services.desktopManager.budgie = {
        enable = true;
        extraPlugins = [
          pkgs.budgie-analogue-clock-applet
        ];
      };

      environment.systemPackages = [ pkgs.wlrctl ];
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      env = "XDG_RUNTIME_DIR=/run/user/${toString user.uid}";
    in
    ''
      with subtest("Wait for login"):
          machine.wait_for_unit("display-manager.service")
          machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")
          machine.wait_until_succeeds('journalctl -t budgie-session-binary --grep "Entering running state"')
          machine.wait_until_succeeds('journalctl --grep "Compositor is fully initialized"')

      with subtest("Check that logging in has given the user ownership of devices"):
          # Change back to /dev/snd/timer after systemd-258.1
          machine.succeed("getfacl -p /dev/dri/card0 | grep -q ${user.name}")

      with subtest("Check if Budgie session components actually start"):
          for i in ["budgie-daemon", "budgie-panel", "labwc", "budgie-session", "swaybg", "swayidle"]:
              machine.wait_until_succeeds(f"pgrep {i}")
          machine.wait_until_succeeds("pgrep -xf ${pkgs.gnome-settings-daemon}/libexec/gsd-sound")
          machine.wait_until_succeeds("pgrep -xf ${pkgs.budgie-desktop-services}/bin/org.buddiesofbudgie.Services")
          machine.wait_until_succeeds("pgrep -xf /run/current-system/sw/bin/org.buddiesofbudgie.budgie-desktop-view")

      with subtest("Check if various environment variables are set"):
          cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf /run/current-system/sw/bin/budgie-panel)/environ"
          machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'Budgie'")
          machine.succeed(f"{cmd} | grep 'BUDGIE_PLUGIN_DATADIR' | grep '${pkgs.budgie-desktop-with-plugins.pname}'")
          # From the nixos/budgie module
          machine.succeed(f"{cmd} | grep 'SSH_AUTH_SOCK' | grep 'gcr'")

      with subtest("Open run dialog"):
          machine.send_key("alt-f2")
          machine.wait_until_succeeds("pgrep -xf budgie-run-dialog")
          machine.sleep(2)
          machine.screenshot("run_dialog")
          machine.send_key("esc")

      with subtest("Open Budgie Control Center"):
          machine.succeed("su - ${user.name} -c '${env} budgie-control-center >&2 &'")
          machine.wait_until_succeeds("su - ${user.name} -c '${env} wlrctl toplevel list | grep org.buddiesofbudgie.ControlCenter'")
          machine.wait_for_text("Network|Ethernet|Control|Connected")

      with subtest("Open GNOME terminal"):
          machine.succeed("su - ${user.name} -c '${env} gnome-terminal >&2 &'")
          machine.wait_until_succeeds("su - ${user.name} -c '${env} wlrctl toplevel list | grep ${user.name}@machine'")

      with subtest("Check if labwc bridge is working"):
          machine.wait_until_succeeds("cat /home/${user.name}/.config/budgie-desktop/labwc/rc.xml | grep Qogir")

      with subtest("Check if Budgie has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep budgie")
          machine.sleep(10)
          machine.screenshot("screen")
    '';
}
