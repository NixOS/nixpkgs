import ./make-test.nix ({ pkgs, ... } : {
  name = "cadvisor";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    machine = { config, pkgs, ... }: {
      services.cadvisor.enable = true;
    };

    influxdb = { config, pkgs, lib, ... }: with lib; {
      services.cadvisor.enable = true;
      services.cadvisor.storageDriver = "influxdb";
      services.influxdb.enable = true;
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("cadvisor.service");
      $machine->succeed("curl http://localhost:8080/containers/");

      $influxdb->waitForUnit("influxdb.service");

      # create influxdb database
      $influxdb->succeed(q~
        curl -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE root"
      ~);

      $influxdb->waitForUnit("cadvisor.service");
      $influxdb->succeed("curl http://localhost:8080/containers/");
    '';
})
