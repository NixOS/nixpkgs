import ./make-test.nix ({ pkgs, ... }: {
  name = "metabase";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.metabase.enable = true;
      virtualisation.memorySize = 1024;
    };
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("metabase.service");
    $machine->waitForOpenPort(3000);
    $machine->waitUntilSucceeds("curl -L http://localhost:3000/setup | grep Metabase");
  '';
})
