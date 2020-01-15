import ./make-test.nix ({ pkgs, ... }: {
  name = "trezord";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.trezord.enable = true;
      services.trezord.emulator.enable = true;
    };
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("trezord.service");
    $machine->waitForOpenPort(21325);
    $machine->waitUntilSucceeds("curl -L http://localhost:21325/status/ | grep Version");
  '';
})
