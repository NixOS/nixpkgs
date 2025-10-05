{ pkgs, lib, ... }:

{
  name = "pantheon";

  meta.maintainers = lib.teams.pantheon.members;

  nodes.machine =
    { ... }:

    let
      videosAutostart = pkgs.writeTextFile {
        name = "autostart-elementary-videos";
        destination = "/etc/xdg/autostart/io.elementary.videos.desktop";
        text = ''
          [Desktop Entry]
          Version=1.0
          Name=Videos
          Type=Application
          Terminal=false
          Exec=io.elementary.videos %U
        '';
      };
    in
    {
      imports = [ ./common/user-account.nix ];

      # Workaround ".gala-wrapped invoked oom-killer"
      virtualisation.memorySize = 2047;

      services.xserver.enable = true;
      services.desktopManager.pantheon.enable = true;

      # We ship pantheon.appcenter by default when this is enabled.
      services.flatpak.enable = true;

      # For basic OCR tests.
      environment.systemPackages = [ videosAutostart ];

      # We don't ship gnome-text-editor in Pantheon module, we add this line mainly
      # to catch eval issues related to this option.
      environment.pantheon.excludePackages = [ pkgs.gnome-text-editor ];

      programs.ydotool.enable = true;
    };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Test we can see usernames in elementary-greeter"):
          machine.wait_for_text("${user.description}")
          machine.wait_until_succeeds("pgrep -f io.elementary.greeter-compositor")
          # Ensure the password box is focused by clicking it.
          # Workaround for https://github.com/NixOS/nixpkgs/issues/211366.
          machine.succeed("ydotool mousemove -a 220 275")
          machine.succeed("ydotool click 0xC0")
          machine.sleep(2)
          machine.screenshot("elementary_greeter_lightdm")

      with subtest("Login with elementary-greeter"):
          machine.send_chars("${user.password}\n")
          machine.wait_until_succeeds('journalctl -t gnome-session-binary --grep "Entering running state"')

      with subtest("Wait for wayland server"):
          machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Check if Pantheon components actually start"):
          pgrep_list = [
              "${pkgs.pantheon.gala}/bin/gala",
              "io.elementary.wingpanel",
              "io.elementary.dock",
              "${pkgs.pantheon.gnome-settings-daemon}/libexec/gsd-media-keys",
              # We specifically check gsd-xsettings here since it is manually pulled up by gala.
              # https://github.com/elementary/gala/pull/2140
              "${pkgs.pantheon.gnome-settings-daemon}/libexec/gsd-xsettings",
              "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit",
              "${pkgs.pantheon.elementary-files}/libexec/io.elementary.files.xdg-desktop-portal"
          ]
          for i in pgrep_list:
              machine.wait_until_succeeds(f"pgrep -xf {i}")

      with subtest("Check if various environment variables are set"):
          cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf ${pkgs.pantheon.gala}/bin/gala)/environ"
          machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'Pantheon'")
          machine.succeed(f"{cmd} | grep 'XDG_SESSION_TYPE' | grep 'wayland'")
          # Hopefully from the sessionPath option.
          machine.succeed(f"{cmd} | grep 'XDG_DATA_DIRS' | grep 'gsettings-schemas/pantheon-agent-geoclue2'")
          # Hopefully from login shell.
          machine.succeed(f"{cmd} | grep '__NIXOS_SET_ENVIRONMENT_DONE' | grep '1'")
          # Hopefully from gcr-ssh-agent.
          machine.succeed(f"{cmd} | grep 'SSH_AUTH_SOCK' | grep 'gcr'")

      with subtest("Wait for elementary videos autostart"):
          machine.wait_until_succeeds("pgrep -xf /run/current-system/sw/bin/io.elementary.videos")
          machine.wait_for_text("No Videos Open")
          machine.screenshot("videos")

      with subtest("Trigger multitasking view"):
          cmd = "dbus-send --session --dest=org.pantheon.gala --print-reply /org/pantheon/gala org.pantheon.gala.PerformAction int32:1"
          env = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus"
          machine.succeed(f"su - ${user.name} -c '{env} {cmd}'")
          machine.sleep(5)
          machine.screenshot("multitasking")
          machine.succeed(f"su - ${user.name} -c '{env} {cmd}'")

      with subtest("Check if gala has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep gala")
          # So we can see the dock.
          machine.execute("pkill -f -9 io.elementary.videos")
          machine.sleep(10)
          machine.screenshot("screen")
    '';
}
