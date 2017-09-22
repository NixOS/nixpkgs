import ./make-test.nix ({ lib, ... }:
{
  name = "grafana";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  machine = { config, pkgs, ... }: {
    services.grafana = {
      enable = true;
      addr = "localhost";
      analytics.reporting.enable = false;
      domain = "localhost";
      security.adminUser = "testusername";
    };
  };

  testScript = ''
    $machine->start;
    $machine->waitForUnit("grafana.service");
    $machine->waitForOpenPort(3000);
    $machine->succeed("curl -sS http://127.0.0.1:3000/");
  '';
})
