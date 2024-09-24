import ../make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "prometheus-remote-write";

  nodes = {
    receiver = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];

      networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

      services.prometheus = {
        enable = true;
        globalConfig.scrape_interval = "2s";

        extraFlags = [ "--web.enable-remote-write-receiver" ];
      };
    };

    prometheus = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];

      networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

      services.prometheus = {
        enable = true;
        globalConfig.scrape_interval = "2s";

        remoteWrite = [
          {
            url = "http://receiver:9090/api/v1/write";
          }
        ];

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "node:${toString config.services.prometheus.exporters.node.port}"
                ];
              }
            ];
          }
        ];
      };
    };

    node = { config, pkgs, ... }: {
      services.prometheus.exporters.node = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  testScript = ''
    node.wait_for_unit("prometheus-node-exporter")
    node.wait_for_open_port(9100)

    for machine in prometheus, receiver:
      machine.wait_for_unit("prometheus")
      machine.wait_for_open_port(9090)

    # Verify both servers got the same data from the exporter
    for machine in prometheus, receiver:
      machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=node_exporter_build_info\{instance=\"node:9100\"\}' | "
        + "jq '.data.result[0].value[1]' | grep '\"1\"'"
      )
  '';
})
