{ lib, pkgs, ... }:

{
  name = "vector-api";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes.machineapi =
    { config, pkgs, ... }:
    {
      services.vector = {
        enable = true;
        journaldAccess = false;
        settings = {
          api.enabled = true;

          sources = {
            demo_logs = {
              type = "demo_logs";
              format = "json";
            };
          };

          sinks = {
            file = {
              type = "file";
              inputs = [ "demo_logs" ];
              path = "/var/lib/vector/logs.log";
              encoding = {
                codec = "json";
              };
            };
          };
        };
      };
    };

  testScript = ''
    machineapi.wait_for_unit("vector")
    machineapi.wait_for_open_port(8686)
    machineapi.succeed("journalctl -o cat -u vector.service | grep 'API server running'")
    machineapi.wait_until_succeeds("curl -sSf http://localhost:8686/health")
  '';
}
