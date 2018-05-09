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
      $machine->succeed("gnome-calculator &");
      $machine->waitForWindow(qr/gnome-calculator/);
      $machine->succeed("xdotool search --sync --onlyvisible --class gnome-calculator windowfocus --sync key ctrl+shift+p");
      $machine->sleep(5); # wait for the popup
      $machine->succeed("xdotool key --delay 100 p r e f e r e n c e s Return");
      $machine->waitForWindow(qr/Preferences/);
      $machine->screenshot("screen");
    '';

})
