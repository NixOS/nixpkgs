{ lib, ... }:
{
  name = "cadvisor";
  meta.maintainers = with lib.maintainers; [ offline ];

  nodes = {
    machine = {
      services.cadvisor.enable = true;
    };

    influxdb = {
      services.cadvisor.enable = true;
      services.cadvisor.storageDriver = "influxdb";
      services.influxdb.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("cadvisor.service")
    machine.succeed("curl -f http://localhost:8080/containers/")

    influxdb.wait_for_unit("influxdb.service")

    # create influxdb database
    influxdb.succeed(
        'curl -f -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE root"'
    )

    influxdb.wait_for_unit("cadvisor.service")
    influxdb.succeed("curl -f http://localhost:8080/containers/")
  '';
}
