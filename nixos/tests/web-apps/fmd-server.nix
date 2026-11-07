{ lib, ... }:

{
  name = "fmd-server";

  nodes = {
    machine = {
      services.fmd-server = {
        enable = true;
        settings = {
          PortInsecure = 80;
          MetricsAddrPort = "[::1]:9100";
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("fmd-server.service")

    machine.wait_for_open_port(80)
    machine.succeed("curl --fail http://localhost", timeout=10)

    machine.wait_for_open_port(9100)
    machine.succeed("curl --fail http://localhost:9100/metrics", timeout=10)
  '';

  meta.maintainers = with lib.maintainers; [ ungeskriptet ];
}
