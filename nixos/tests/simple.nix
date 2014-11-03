import ./make-test.nix {
  name = "simple";

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
}
