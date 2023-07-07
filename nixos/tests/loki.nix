import ./make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "loki";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  nodes.machine = { ... }: {
    services.loki = {
      enable = true;
      configFile = "${pkgs.grafana-loki.src}/cmd/loki/loki-local-config.yaml";
    };
    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };
        clients = [ { url = "http://localhost:3100/loki/api/v1/push"; } ];
        scrape_configs = [
          {
            job_name = "system";
            static_configs = [
              {
                targets = [ "localhost" ];
                labels = {
                  job = "varlogs";
                  __path__ = "/var/log/*log";
                };
              }
            ];
          }
        ];
      };
    };
  };

  testScript = ''
    machine.start
    machine.wait_for_unit("loki.service")
    machine.wait_for_unit("promtail.service")
    machine.wait_for_open_port(3100)
    machine.wait_for_open_port(9080)
    machine.succeed("echo 'Loki Ingestion Test' > /var/log/testlog")
    # should not have access to journal unless specified
    machine.fail(
        "systemctl show --property=SupplementaryGroups promtail | grep -q systemd-journal"
    )
    machine.wait_until_succeeds(
        "${pkgs.grafana-loki}/bin/logcli --addr='http://localhost:3100' query --no-labels '{job=\"varlogs\",filename=\"/var/log/testlog\"}' | grep -q 'Loki Ingestion Test'"
    )
  '';
})
