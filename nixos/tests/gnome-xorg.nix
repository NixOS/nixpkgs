import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "gnome-xorg";
    meta = {
      maintainers = lib.teams.gnome.members;
    };

    nodes.machine =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in

      {
        imports = [ ./common/user-account.nix ];

        services.xserver.enable = true;

        services.xserver.displayManager = {
          gdm.enable = true;
          gdm.debug = true;
        };

        services.displayManager.autoLogin = {
          enable = true;
          user = user.name;
        };

        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.desktopManager.gnome.debug = true;
        services.displayManager.defaultSession = "gnome-xorg";

        systemd.user.services = {
          "org.gnome.Shell@x11" = {
            serviceConfig = {
              ExecStart = [
                # Clear the list before overriding it.
                ""
                # Eval API is now internal so Shell needs to run in unsafe mode.
                # TODO: improve test driver so that it supports openqa-like manipulation
                # that would allow us to drop this mess.
                "${pkgs.gnome-shell}/bin/gnome-shell --unsafe-mode"
              ];
            };
          };
        };

      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
        uid = toString user.uid;
        bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
        xauthority = "/run/user/${uid}/gdm/Xauthority";
        display = "DISPLAY=:0.0";
        env = "${bus} XAUTHORITY=${xauthority} ${display}";
        # Run a command in the appropriate user environment
        run = command: "su - ${user.name} -c '${bus} ${command}'";

        # Call javascript in gnome shell, returns a tuple (success, output), where
        # `success` is true if the dbus call was successful and output is what the
        # javascript evaluates to.
        eval =
          command:
          run "gdbus call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval ${command}";

        # False when startup is done
        startingUp = eval "Main.layoutManager._startingUp";

        # Start Console
        launchConsole = run "gapplication launch org.gnome.Console";

        # Hopefully Console's wm class
        wmClass = eval "global.display.focus_window.wm_class";
      in
      ''
        with subtest("Login to GNOME Xorg with GDM"):
            machine.wait_for_x()
            # Wait for alice to be logged in"
            machine.wait_for_unit("default.target", "${user.name}")
            machine.wait_for_file("${xauthority}")
            machine.succeed("xauth merge ${xauthority}")
            # Check that logging in has given the user ownership of devices
            assert "alice" in machine.succeed("getfacl -p /dev/snd/timer")

        with subtest("Wait for GNOME Shell"):
            # correct output should be (true, 'false')
            machine.wait_until_succeeds(
                "${startingUp} | grep -q 'true,..false'"
            )

        with subtest("Open Console"):
            # Close the Activities view so that Shell can correctly track the focused window.
            machine.send_key("esc")

            machine.succeed(
                "${launchConsole}"
            )
            # correct output should be (true, '"kgx"')
            # For some reason, this deviates from Wayland.
            machine.wait_until_succeeds(
                "${wmClass} | grep -q  'true,...kgx'"
            )
            machine.sleep(20)
            machine.screenshot("screen")
      '';
  }
)
