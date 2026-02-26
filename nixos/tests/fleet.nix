{ lib, ... }:
{
  name = "fleet";
  meta.maintainers = with lib.maintainers; [ bddvlpr ];

  nodes.machine = {
    services.fleet = {
      enable = true;

      createDatabaseLocally = true;
      createRedisLocally = true;

      settings.server.tls = false;
    };
  };

  testScript = ''
    machine.wait_for_unit("fleet.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080/")
  '';
}
