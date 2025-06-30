{ lib, pkgs, ... }:

{
  name = "vector-test1";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.vector = {
        enable = true;
        journaldAccess = true;
        settings = {
          sources = {
            journald.type = "journald";

            vector_metrics.type = "internal_metrics";

            vector_logs.type = "internal_logs";
          };

          sinks = {
            file = {
              type = "file";
              inputs = [
                "journald"
                "vector_logs"
              ];
              path = "/var/lib/vector/logs.log";
              encoding = {
                codec = "json";
              };
            };

            prometheus_exporter = {
              type = "prometheus_exporter";
              inputs = [ "vector_metrics" ];
              address = "[::]:9598";
            };
          };
        };
      };
    };

  # ensure vector is forwarding the messages appropriately
  testScript = ''
    machine.wait_for_unit("vector.service")
    machine.wait_for_open_port(9598)
    machine.wait_until_succeeds("journalctl -o cat -u vector.service | grep 'version=\"${pkgs.vector.version}\"'")
    machine.wait_until_succeeds("journalctl -o cat -u vector.service | grep 'API is disabled'")
    machine.wait_until_succeeds("curl -sSf http://localhost:9598/metrics | grep vector_build_info")
    machine.wait_until_succeeds("curl -sSf http://localhost:9598/metrics | grep vector_component_received_bytes_total | grep journald")
    machine.wait_until_succeeds("curl -sSf http://localhost:9598/metrics | grep vector_utilization | grep prometheus_exporter")
    machine.wait_for_file("/var/lib/vector/logs.log")
  '';
}
