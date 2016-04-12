import ./make-test.nix ({ pkgs, ...} : {
  name = "gnome3-gdm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lethalman ];
  };

  machine =
    { config, pkgs, ... }:

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
      $machine->sleep(20);
      $machine->screenshot("screen");
    '';
})
