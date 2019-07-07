import ./make-test.nix ({ pkgs, ...} : {
  name = "gnome3-gdm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lethalman ];
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

  testScript = let
    # Keep line widths somewhat managable
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus";
    gdbus = "${bus} gdbus";
    # Call javascript in gnome shell, returns a tuple (success, output), where
    # `success` is true if the dbus call was successful and output is what the
    # javascript evaluates to.
    eval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";
    # False when startup is done
    startingUp = "${gdbus} ${eval} Main.layoutManager._startingUp";
    # Hopefully gnome-terminal's wm class
    wmClass = "${gdbus} ${eval} global.display.focus_window.wm_class";
  in ''
      # wait for gdm to start
      $machine->waitForUnit("display-manager.service");

      # wait for alice to be logged in
      $machine->waitForUnit("default.target","alice");

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      # Wait for the wayland server
      $machine->waitForFile("/run/user/1000/wayland-0");

      # Wait for gnome shell, correct output should be "(true, 'false')"
      $machine->waitUntilSucceeds("su - alice -c '${startingUp} | grep -q true,..false'");

      # open a terminal
      $machine->succeed("su - alice -c '${bus} gnome-terminal'");
      # and check it's there
      $machine->waitUntilSucceeds("su - alice -c '${wmClass} | grep -q gnome-terminal-server'");

      # wait to get a nice screenshot
      $machine->sleep(20);
      $machine->screenshot("screen");
    '';
})
