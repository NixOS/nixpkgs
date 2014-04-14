import ./make-test.nix {

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
}
