import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "statsd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  machine = {
    services.statsd.enable = true;
    services.statsd.backends = [ "statsd-influxdb-backend" "console" ];
    services.statsd.extraConfig = ''
      influxdb: {
        username: "root",
        password: "root",
        database: "statsd"
      }
    '';

    services.influxdb.enable = true;

    systemd.services.influx-init = {
      description = "Setup Influx Test Base";
      after = [ "influxdb.service" ];
      before = [ "statsd.service" ];

      script = ''
        echo "CREATE DATABASE statsd" | ${pkgs.influxdb}/bin/influx
      '';
    };
  };

  testScript = ''
    $machine->start();
    $machine->waitForUnit("statsd.service");
    $machine->waitForOpenPort(8126);

    # check state of the `statsd` server
    $machine->succeed('[ "health: up" = "$(echo health | nc 127.0.0.1 8126 -w 120 -N)" ];');

    # confirm basic examples for metrics derived from docs:
    # https://github.com/etsy/statsd/blob/v0.8.0/README.md#usage and
    # https://github.com/etsy/statsd/blob/v0.8.0/docs/admin_interface.md
    $machine->succeed("echo 'foo:1|c' | nc -u -w 0  127.0.0.1 8125");
    $machine->succeed("echo counters | nc -w 120 127.0.0.1 8126 -N | grep foo");
    $machine->succeed("echo 'delcounters foo' | nc -w 120 127.0.0.1 8126 -N");
    $machine->fail("echo counters | nc -w 120 127.0.0.1 8126 -N | grep foo");
  '';
})
