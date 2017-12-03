import ./make-test.nix ({ lib, ... }:
{
  name = "dillinger";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  machine = { config, pkgs, ... }: {
    services.dillinger = {
      enable = true;
      listenAddress = "localhost";
      port = 2305;
    };
  };

  testScript = ''
    $machine->start;
    $machine->waitForUnit("dillinger.service");
    $machine->waitForOpenPort(2305);
    $machine->succeed("curl -fsS http://127.0.0.1:2305/");
  '';
})
