{ lib, ... }:
{
  name = "victoriatraces-service-endpoints";
  meta.maintainers = with lib.maintainers; [ cmacrae ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.victoriatraces = {
        enable = true;
        extraOptions = [
          "-loggerLevel=WARN"
        ];
      };

      environment.systemPackages = with pkgs; [
        curl
        jq
      ];
    };

  testScript = ''
    machine.wait_for_unit("victoriatraces.service")
    machine.wait_for_open_port(10428)

    with subtest("Service endpoints are accessible"):
        machine.succeed("curl --fail http://localhost:10428/")
        machine.succeed("curl --fail http://localhost:10428/select/vmui")
        machine.succeed("curl --fail http://localhost:10428/metrics | grep -E '^(vm_|process_)'")
        machine.succeed("curl --fail http://localhost:10428/select/jaeger/api/services")

    with subtest("OTLP trace ingestion endpoint accepts requests"):
        machine.succeed("curl --fail -X POST http://localhost:10428/insert/opentelemetry/v1/traces -H 'Content-Type: application/x-protobuf'")
        machine.succeed("test -d /var/lib/victoriatraces")
  '';
}
