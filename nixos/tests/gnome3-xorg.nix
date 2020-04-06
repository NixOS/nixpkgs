import ./make-test-python.nix ({ pkgs, ...} : {
  name = "gnome3-xorg";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = pkgs.gnome3.maintainers;
  };

  machine = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.gdm = {
        enable = true;
        autoLogin = {
          enable = true;
          user = user.name;
        };
      };

      services.xserver.desktopManager.gnome3.enable = true;
      services.xserver.displayManager.defaultSession = "gnome-xorg";

      virtualisation.memorySize = 1024;
    };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
    uid = toString user.uid;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
    xauthority = "/run/user/${uid}/gdm/Xauthority";
    display = "DISPLAY=:0.0";
    env = "${bus} XAUTHORITY=${xauthority} ${display}";
    gdbus = "${env} gdbus";
    su = command: "su - ${user.name} -c '${env} ${command}'";

    # Call javascript in gnome shell, returns a tuple (success, output), where
    # `success` is true if the dbus call was successful and output is what the
    # javascript evaluates to.
    eval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";

    # False when startup is done
    startingUp = su "${gdbus} ${eval} Main.layoutManager._startingUp";

    # Start gnome-terminal
    gnomeTerminalCommand = su "gnome-terminal";

    # Hopefully gnome-terminal's wm class
    wmClass = su "${gdbus} ${eval} global.display.focus_window.wm_class";
  in ''
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

      with subtest("Open Gnome Terminal"):
          machine.succeed(
              "${gnomeTerminalCommand}"
          )
          # correct output should be (true, '"Gnome-terminal"')
          machine.wait_until_succeeds(
              "${wmClass} | grep -q  'true,...Gnome-terminal'"
          )
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})
