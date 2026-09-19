{ lib, ... }:

{
  name = "otelite";
  meta.maintainers = [ lib.maintainers.zatevakhin ];

  nodes.machine.services.otelite = {
    enable = true;
    otlpGrpcPort = 14317;
    otlpHttpPort = 14318;
  };

  testScript = ''
    machine.wait_for_unit("otelite.service")
    machine.wait_for_open_port(3000)
    machine.wait_for_open_port(14317)
    machine.wait_for_open_port(14318)
    machine.succeed("curl --fail http://localhost:3000/api/health | grep -F '\"otlp_grpc_port\":14317'")
    machine.succeed("curl --fail http://localhost:3000/api/health | grep -F '\"otlp_http_port\":14318'")
    machine.succeed("test $(stat -Lc %a /var/lib/otelite) = 750")
  '';
}
