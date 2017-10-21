import ./make-test.nix ({ pkgs, ... }: {
  name = "firefox";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow shlevy ];
  };

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.firefox pkgs.xdotool ];
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->execute("xterm -e 'firefox file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' &");
      $machine->waitForWindow(qr/Valgrind/);
      $machine->sleep(40); # wait until Firefox has finished loading the page
      $machine->execute("xdotool key space"); # do I want to make Firefox the
                             # default browser? I just want to close the dialog
      $machine->sleep(2); # wait until Firefox hides the default browser window
      $machine->execute("xdotool key F12");
      $machine->sleep(10); # wait until Firefox draws the developer tool panel
      $machine->succeed("xwininfo -root -tree | grep Valgrind");
      $machine->screenshot("screen");
    '';

})
