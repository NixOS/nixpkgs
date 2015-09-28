import ./make-test.nix ({ pkgs, ... }: {
  name = "firefox";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow shlevy ];
  };

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.firefox ];
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->execute("firefox file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html &");
      $machine->waitForWindow(qr/Valgrind/);
      $machine->sleep(40); # wait until Firefox has finished loading the page
      $machine->screenshot("screen");
    '';

})
