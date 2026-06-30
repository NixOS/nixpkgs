{ pkgs, ... }:
{
  name = "cortex-metrics";
  nodes = {
    server =
      { ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
        services.cortex-metrics.enable = true;
        services.cortex-metrics.configuration = {
          auth_enabled = true;
          server.http_listen_port = 8080;
          ingester.lifecycler = {
            ring = {
              kvstore.store = "inmemory";
              replication_factor = 1;
            };
            final_sleep = "0s";
            min_ready_duration = "0s";
          };
          blocks_storage = {
            backend = "filesystem";
            filesystem.dir = "/var/lib/cortex-metrics/data";
            tsdb.dir = "/var/lib/cortex-metrics/tsdb";
            bucket_store.sync_dir = "/var/lib/cortex-metrics/tsdb-sync";
          };
          ruler_storage = {
            backend = "local";
            local.directory = "/var/lib/cortex-metrics/rules";
          };
        };

        services.telegraf.enable = true;
        services.telegraf.extraConfig = {
          agent.interval = "1s";
          agent.flush_interval = "1s";
          inputs.exec = {
            commands = [
              "${pkgs.coreutils}/bin/echo 'foo i=42i'"
            ];
            data_format = "influx";
          };
          outputs = {
            http = {
              # test remote write
              url = "http://localhost:8080/api/v1/push";

              # Data format to output.
              data_format = "prometheusremotewrite";

              headers = {
                Content-Type = "application/x-protobuf";
                Content-Encoding = "snappy";
                X-Scope-OrgID = "nixos";
                X-Prometheus-Remote-Write-Version = "0.1.0";
              };
            };
          };
        };
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("cortex-metrics.service")
    server.wait_for_unit("telegraf.service")
    server.wait_for_open_port(8080)
    server.wait_until_succeeds(
        "curl -H 'X-Scope-OrgID: nixos' http://127.0.0.1:8080/prometheus/api/v1/label/host/values | jq -r '.data[0]' | grep server"
    )
  '';
}
