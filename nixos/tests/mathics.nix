import ./make-test.nix ({ pkgs, ... }: {
  name = "mathics";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ benley ];
  };

  nodes = {
    machine = { config, pkgs, ... }: {
      services.mathics.enable = true;
      services.mathics.port = 8888;
    };
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("mathics.service");
    $machine->waitForOpenPort(8888);
    $machine->succeed("curl http://localhost:8888/");
  '';
})
