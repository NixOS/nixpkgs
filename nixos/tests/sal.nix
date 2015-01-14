import ./make-test.nix {
  name = "sal";

  machine = { config, pkgs, ... }: {
    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql92;
    services.mongodb.enable = true;
    services.mongodb.extraConfig = ''
      nojournal = true
    '';
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("mongodb.service");
      $machine->shutdown;
    '';
}
