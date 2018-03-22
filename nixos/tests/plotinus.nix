import ./make-test.nix ({ pkgs, ... }: {
  name = "plotinus";
  meta = {
    maintainers = pkgs.plotinus.meta.maintainers;
  };

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      programs.plotinus.enable = true;
      environment.systemPackages = [ pkgs.gnome3.gnome-calculator pkgs.xdotool ];
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->execute("xterm -e 'gnome-calculator' &");
      $machine->waitForWindow(qr/Calculator/);
      $machine->execute("xdotool key ctrl+shift+p");
      $machine->sleep(1); # wait for the popup
      $machine->execute("xdotool key p r e f e r e n c e s Return");
      $machine->waitForWindow(qr/Preferences/);
      $machine->screenshot("screen");
    '';

})
