import ./make-test.nix {
  name = "xfce";

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";

      services.xserver.desktopManager.xfce.enable = true;
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->waitForWindow(qr/xfce4-panel/);
      $machine->sleep(10);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 xfce4-terminal &'");
      $machine->waitForWindow(qr/Terminal/);
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';

}
