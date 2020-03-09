import ./make-test-python.nix ({ pkgs, ...} : {
  name = "gnome3";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = pkgs.gnome3.maintainers;
  };

  machine =
    { ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.gdm = {
        enable = true;
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };

      services.xserver.desktopManager.gnome3.enable = true;

      virtualisation.memorySize = 1024;
    };

  testScript = { nodes, ... }: let
    # Keep line widths somewhat managable
    user = nodes.machine.config.users.users.alice;
    uid = toString user.uid;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
    gdbus = "${bus} gdbus";
    su = command: "su - ${user.name} -c '${command}'";

    # Call javascript in gnome shell, returns a tuple (success, output), where
    # `success` is true if the dbus call was successful and output is what the
    # javascript evaluates to.
    eval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";

    # False when startup is done
    startingUp = su "${gdbus} ${eval} Main.layoutManager._startingUp";

    # Start gnome-terminal
    gnomeTerminalCommand = su "${bus} gnome-terminal";

    # Hopefully gnome-terminal's wm class
    wmClass = su "${gdbus} ${eval} global.display.focus_window.wm_class";
  in ''
      with subtest("Login to GNOME with GDM"):
          # wait for gdm to start
          machine.wait_for_unit("display-manager.service")
          # wait for the wayland server
          machine.wait_for_file("/run/user/${uid}/wayland-0")
          # wait for alice to be logged in
          machine.wait_for_unit("default.target", "${user.name}")
          # check that logging in has given the user ownership of devices
          assert "alice" in machine.succeed("getfacl -p /dev/snd/timer")

      with subtest("Wait for GNOME Shell"):
          # correct output should be (true, 'false')
          machine.wait_until_succeeds(
              "${startingUp} | grep -q 'true,..false'"
          )

      with subtest("Open Gnome Terminal"):
          machine.succeed(
              "${gnomeTerminalCommand}"
          )
          # correct output should be (true, '"gnome-terminal-server"')
          machine.wait_until_succeeds(
              "${wmClass} | grep -q 'gnome-terminal-server'"
          )
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})
