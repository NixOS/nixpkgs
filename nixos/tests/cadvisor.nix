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
      systemd.services.influxdb.postStart = mkAfter ''
        ${pkgs.curl.bin}/bin/curl -X POST 'http://localhost:8086/db?u=root&p=root' \
          -d '{"name": "root"}'
      '';
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("cadvisor.service");
      $machine->succeed("curl http://localhost:8080/containers/");

      $influxdb->waitForUnit("influxdb.service");
      $influxdb->waitForUnit("cadvisor.service");
      $influxdb->succeed("curl http://localhost:8080/containers/");
    '';
})
