import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "pantheon";

  meta.maintainers = lib.teams.pantheon.members;

  nodes.machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];

    services.xserver.enable = true;
    services.xserver.desktopManager.pantheon.enable = true;

    # We ship pantheon.appcenter by default when this is enabled.
    services.flatpak.enable = true;

    # We don't ship gnome-text-editor in Pantheon module, we add this line mainly
    # to catch eval issues related to this option.
    environment.pantheon.excludePackages = [ pkgs.gnome-text-editor ];

    environment.systemPackages = [ pkgs.xdotool ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.users.users.alice;
    bob = nodes.machine.users.users.bob;
  in ''
    machine.wait_for_unit("display-manager.service")

    with subtest("Test we can see usernames in elementary-greeter"):
        machine.wait_for_text("${user.description}")
        machine.wait_until_succeeds("pgrep -f io.elementary.greeter-compositor")
        # OCR was struggling with this one.
        # machine.wait_for_text("${bob.description}")
        # Ensure the password box is focused by clicking it.
        # Workaround for https://github.com/NixOS/nixpkgs/issues/211366.
        machine.succeed("XAUTHORITY=/var/lib/lightdm/.Xauthority DISPLAY=:0 xdotool mousemove 512 505 click 1")
        machine.sleep(2)
        machine.screenshot("elementary_greeter_lightdm")

    with subtest("Login with elementary-greeter"):
        machine.send_chars("${user.password}\n")
        machine.wait_for_x()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.wait_until_succeeds('journalctl -t gnome-session-binary --grep "Entering running state"')

    with subtest("Check that logging in has given the user ownership of devices"):
        machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

    with subtest("Check if Pantheon components actually start"):
        for i in ["gala", "io.elementary.wingpanel", "plank", "gsd-media-keys", "io.elementary.desktop.agent-polkit"]:
            machine.wait_until_succeeds(f"pgrep -f {i}")
        for i in ["gala", "io.elementary.wingpanel", "plank"]:
            machine.wait_for_window(i)
        for i in ["bamfdaemon.service", "io.elementary.files.xdg-desktop-portal.service"]:
            machine.wait_for_unit(i, "${user.name}")

    with subtest("Check if various environment variables are set"):
        cmd = "xargs --null --max-args=1 echo < /proc/$(pgrep -xf ${pkgs.pantheon.gala}/bin/gala)/environ"
        machine.succeed(f"{cmd} | grep 'XDG_CURRENT_DESKTOP' | grep 'Pantheon'")
        # Hopefully from the sessionPath option.
        machine.succeed(f"{cmd} | grep 'XDG_DATA_DIRS' | grep 'gsettings-schemas/pantheon-agent-geoclue2'")
        # Hopefully from login shell.
        machine.succeed(f"{cmd} | grep '__NIXOS_SET_ENVIRONMENT_DONE' | grep '1'")
        # See elementary-session-settings packaging.
        machine.succeed(f"{cmd} | grep 'XDG_CONFIG_DIRS' | grep 'elementary-default-settings'")

    with subtest("Open elementary videos"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.videos >&2 &'")
        machine.sleep(2)
        machine.wait_for_window("io.elementary.videos")
        machine.wait_for_text("No Videos Open")

    with subtest("Open elementary calendar"):
        machine.wait_until_succeeds("pgrep -f evolution-calendar-factory")
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.calendar >&2 &'")
        machine.sleep(2)
        machine.wait_for_window("io.elementary.calendar")

    with subtest("Open system settings"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.switchboard >&2 &'")
        # Wait for all plugins to be loaded before we check if the window is still there.
        machine.sleep(5)
        machine.wait_for_window("io.elementary.switchboard")

    with subtest("Open elementary terminal"):
        machine.execute("su - ${user.name} -c 'DISPLAY=:0 io.elementary.terminal >&2 &'")
        machine.wait_for_window("io.elementary.terminal")

    with subtest("Trigger multitasking view"):
        cmd = "dbus-send --session --dest=org.pantheon.gala --print-reply /org/pantheon/gala org.pantheon.gala.PerformAction int32:1"
        env = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus DISPLAY=:0"
        machine.succeed(f"su - ${user.name} -c '{env} {cmd}'")
        machine.sleep(3)
        machine.screenshot("multitasking")
        machine.succeed(f"su - ${user.name} -c '{env} {cmd}'")

    with subtest("Check if gala has ever coredumped"):
        machine.fail("coredumpctl --json=short | grep gala")
        # So you can see the dock in the below screenshot.
        machine.succeed("su - ${user.name} -c 'DISPLAY=:0 xdotool mousemove 450 1000 >&2 &'")
        machine.sleep(10)
        machine.screenshot("screen")
  '';
})
