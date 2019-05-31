import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "osquery";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  machine = {
    services.osquery.enable = true;
    services.osquery.loggerPath = "/var/log/osquery/logs";
    services.osquery.pidfile = "/run/osqueryd.pid";
  };

  testScript = ''
    $machine->start;
    $machine->waitForUnit("osqueryd.service");

    $machine->succeed("echo 'SELECT address FROM etc_hosts LIMIT 1;' | osqueryi | grep '127.0.0.1'");
    $machine->succeed(
      "echo 'SELECT value FROM osquery_flags WHERE name = \"logger_path\";' | osqueryi | grep /var/log/osquery/logs"
    );

    $machine->succeed("echo 'SELECT value FROM osquery_flags WHERE name = \"pidfile\";' | osqueryi | grep /run/osqueryd.pid");
  '';
})
