import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "pantheon-wayland";

    meta.maintainers = lib.teams.pantheon.members;

    nodes.machine =
      { nodes, ... }:

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
        services.xserver.desktopManager.pantheon.enable = true;
        services.displayManager = {
          autoLogin.enable = true;
          autoLogin.user = nodes.machine.users.users.alice.name;
          defaultSession = "pantheon-wayland";
        };

        # We ship pantheon.appcenter by default when this is enabled.
        services.flatpak.enable = true;

        # For basic OCR tests.
        environment.systemPackages = [ videosAutostart ];

        # We don't ship gnome-text-editor in Pantheon module, we add this line mainly
        # to catch eval issues related to this option.
        environment.pantheon.excludePackages = [ pkgs.gnome-text-editor ];
      };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      ''
        machine.wait_for_unit("display-manager.service")

        with subtest("Wait for wayland server"):
            machine.wait_for_file("/run/user/${toString user.uid}/wayland-0")

        with subtest("Check that logging in has given the user ownership of devices"):
            machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

        with subtest("Check if Pantheon components actually start"):
            # We specifically check gsd-xsettings here since it is manually pulled up by gala.
            # https://github.com/elementary/gala/pull/2140
            for i in ["gala", "io.elementary.wingpanel", "io.elementary.dock", "gsd-media-keys", "gsd-xsettings", "io.elementary.desktop.agent-polkit"]:
                machine.wait_until_succeeds(f"pgrep -f {i}")
            for i in ["io.elementary.files.xdg-desktop-portal.service"]:
                machine.wait_for_unit(i, "${user.name}")

        with subtest("Check if various environment variables are set"):
            cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf ${pkgs.pantheon.gala}/bin/gala)/environ"
            machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'Pantheon'")
            machine.succeed(f"{cmd} | grep 'XDG_SESSION_TYPE' | grep 'wayland'")
            # Hopefully from the sessionPath option.
            machine.succeed(f"{cmd} | grep 'XDG_DATA_DIRS' | grep 'gsettings-schemas/pantheon-agent-geoclue2'")
            # Hopefully from login shell.
            machine.succeed(f"{cmd} | grep '__NIXOS_SET_ENVIRONMENT_DONE' | grep '1'")

        with subtest("Wait for elementary videos autostart"):
            machine.wait_until_succeeds("pgrep -f io.elementary.videos")
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
)
