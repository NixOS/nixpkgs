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

  testScript =
    ''
      # wait for gdm to start and bring up X
      $machine->waitForUnit("display-manager.service");
      $machine->waitForX;

      # wait for alice to be logged in
      $machine->waitForUnit("default.target","alice");

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      # open a terminal and check it's there
      $machine->succeed("su - alice -c 'DISPLAY=:0.0 XAUTHORITY=/run/user/\$UID/gdm/Xauthority gnome-terminal'");
      $machine->succeed("xauth merge /run/user/1000/gdm/Xauthority");
      $machine->waitForWindow(qr/Terminal/);

      # wait to get a nice screenshot
      $machine->sleep(20);
      $machine->screenshot("screen");
    '';
})
