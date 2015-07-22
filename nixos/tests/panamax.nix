import ./make-test.nix ({ pkgs, ...} : {
  name = "panamax";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  machine = { config, pkgs, ... }: {
    services.panamax.enable = true;
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("panamax-api.service");
      $machine->waitForUnit("panamax-ui.service");
      $machine->waitForOpenPort(3000);
      $machine->waitForOpenPort(8888);
      $machine->succeed("curl --fail http://localhost:8888/ > /dev/null");
      $machine->shutdown;
    '';
})
