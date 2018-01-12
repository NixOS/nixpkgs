import ./make-test.nix ({ pkgs, lib }:

with lib;

{
  name = "statsd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.statsd1 = {
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
    $statsd1->start();
    $statsd1->waitForUnit("statsd.service");
    $statsd1->succeed("nc -z 127.0.0.1 8126");
  '';
})
