import ./make-test.nix ({ pkgs, ... }: {
  name = "trac";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    machine = { ... }: {
      services.trac.enable = true;
    };
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("trac.service");
    $machine->waitForOpenPort(8000);
    $machine->waitUntilSucceeds("curl -L http://localhost:8000/ | grep 'Trac Powered'");
  '';
})
