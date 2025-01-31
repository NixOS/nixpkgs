import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "cinnamon";

  meta.maintainers = lib.teams.cinnamon.members;

  nodes.machine = { ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    # We don't ship gnome-text-editor in Cinnamon module, we add this line mainly
    # to catch eval issues related to this option.
    environment.cinnamon.excludePackages = [ pkgs.gnome-text-editor ];

    # For the sessionPath subtest.
    services.xserver.desktopManager.cinnamon.sessionPath = [ pkgs.gpaste ];
  };

  enableOCR = true;

  testScript = { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      env = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus DISPLAY=:0";
      su = command: "su - ${user.name} -c '${env} ${command}'";

      # Call javascript in cinnamon (the shell), returns a tuple (success, output),
      # where `success` is true if the dbus call was successful and `output` is what
      # the javascript evaluates to.
      eval = name: su "gdbus call --session -d org.Cinnamon -o /org/Cinnamon -m org.Cinnamon.Eval ${name}";
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Test if we can see username in slick-greeter"):
          machine.wait_for_text("${user.description}")
          machine.screenshot("slick_greeter_lightdm")

      with subtest("Login with slick-greeter"):
          machine.send_chars("${user.password}\n")
          machine.wait_for_x()
          machine.wait_for_file("${user.home}/.Xauthority")
          machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Wait for the Cinnamon shell"):
          # Correct output should be (true, '2')
          # https://github.com/linuxmint/cinnamon/blob/5.4.0/js/ui/main.js#L183-L187
          machine.wait_until_succeeds("${eval "Main.runState"} | grep -q 'true,..2'")

      with subtest("Check if Cinnamon components actually start"):
          for i in ["csd-media-keys", "cinnamon-killer-daemon", "xapp-sn-watcher", "nemo-desktop"]:
            machine.wait_until_succeeds(f"pgrep -f {i}")
          machine.wait_until_succeeds("journalctl -b --grep 'Loaded applet menu@cinnamon.org'")
          machine.wait_until_succeeds("journalctl -b --grep 'calendar@cinnamon.org: Calendar events supported'")

      with subtest("Check if sessionPath option actually works"):
          machine.succeed("${eval "imports.gi.GIRepository.Repository.get_search_path\\(\\)"} | grep gpaste")

      with subtest("Open Cinnamon Settings"):
          machine.succeed("${su "cinnamon-settings themes >&2 &"}")
          machine.wait_until_succeeds("${eval "global.display.focus_window.wm_class"} | grep -i 'cinnamon-settings'")
          machine.wait_for_text('(Style|Appearance|Color)')
          machine.sleep(2)
          machine.screenshot("cinnamon_settings")

      with subtest("Lock the screen"):
          machine.succeed("${su "cinnamon-screensaver-command -l >&2 &"}")
          machine.wait_until_succeeds("${su "cinnamon-screensaver-command -q"} | grep 'The screensaver is active'")
          machine.sleep(2)
          machine.screenshot("cinnamon_screensaver")
          machine.send_chars("${user.password}\n", delay=0.2)
          machine.wait_until_succeeds("${su "cinnamon-screensaver-command -q"} | grep 'The screensaver is inactive'")
          machine.sleep(2)

      with subtest("Open GNOME Terminal"):
          machine.succeed("${su "gnome-terminal"}")
          machine.wait_until_succeeds("${eval "global.display.focus_window.wm_class"} | grep -i 'gnome-terminal'")
          machine.sleep(2)

      with subtest("Open virtual keyboard"):
          machine.succeed("${su "dbus-send --print-reply --dest=org.Cinnamon /org/Cinnamon org.Cinnamon.ToggleKeyboard"}")
          machine.wait_for_text('(Ctrl|Alt)')
          machine.sleep(2)
          machine.screenshot("cinnamon_virtual_keyboard")

      with subtest("Check if Cinnamon has ever coredumped"):
          machine.fail("coredumpctl --json=short | grep -E 'cinnamon|nemo'")
    '';
})
