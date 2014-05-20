import ./make-test.nix {

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";
      services.xserver.desktopManager.gnome3.enable = true;
      environment.gnome3.packageSet = pkgs.gnome3_12;
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->sleep(15);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 gnome-terminal &'");
      $machine->waitForWindow(qr/Terminal/);
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';

}
