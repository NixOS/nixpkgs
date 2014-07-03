import ./make-test.nix ({ pkgs, ... }: {
  name = "firefox";

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.firefox ];
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->execute("firefox file://${pkgs.valgrind}/share/doc/valgrind/html/index.html &");
      $machine->waitForWindow(qr/Valgrind/);
      $machine->sleep(40); # wait until Firefox has finished loading the page
      $machine->screenshot("screen");
    '';

})
