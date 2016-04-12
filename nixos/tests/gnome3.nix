import ./make-test.nix ({ pkgs, ...} : {
  name = "gnome3";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ iElectric eelco chaoflow lethalman ];
  };

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";
      services.xserver.desktopManager.gnome3.enable = true;

      virtualisation.memorySize = 512;
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->sleep(15);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 gnome-terminal &'");
      $machine->succeed("xauth merge ~alice/.Xauthority");
      $machine->waitForWindow(qr/Terminal/);
      $machine->mustSucceed("timeout 900 bash -c 'journalctl -f|grep -m 1 \"GNOME Shell started\"'");
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';
})
