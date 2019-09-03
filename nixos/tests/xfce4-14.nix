import ./make-test.nix ({ pkgs, ...} : {
  name = "xfce4-14";

  machine =
    { pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";

      services.xserver.desktopManager.xfce4-14.enable = true;
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->waitForFile("/home/alice/.Xauthority");
      $machine->succeed("xauth merge ~alice/.Xauthority");
      $machine->waitForWindow(qr/xfce4-panel/);
      $machine->sleep(10);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 xfce4-terminal &'");
      $machine->waitForWindow(qr/Terminal/);
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';
})
