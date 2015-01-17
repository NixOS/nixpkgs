import ./make-test.nix {
  name = "sal";

  machine = { config, pkgs, ... }: {
    services.mongodb.enable = true;
    services.mongodb.extraConfig = ''
      nojournal = true
    '';
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("elasticsearch.service");
      $machine->shutdown;
    '';
}
