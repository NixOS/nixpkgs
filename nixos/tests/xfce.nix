import ./make-test.nix ({ pkgs, ...} : {
  name = "xfce";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow shlevy ];
  };

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";

      services.xserver.desktopManager.xfce.enable = true;

      environment.systemPackages = [ pkgs.xorg.xmessage ];
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

      # Ensure that the X server does proper access control.
      $machine->mustFail("su - bob -c 'DISPLAY=:0.0 xmessage Foo'");
      $machine->mustFail("su - bob -c 'DISPLAY=:0 xmessage Foo'");
    '';
})
