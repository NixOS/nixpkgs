{
  name = "prometheus-federation";

  nodes = {
    global1 =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";

          scrapeConfigs = [
            {
              job_name = "federate";
              honor_labels = true;
              metrics_path = "/federate";

              params = {
                "match[]" = [
                  "{job=\"node\"}"
                  "{job=\"prometheus\"}"
                ];
              };

              static_configs = [
                {
                  targets = [
                    "prometheus1:${toString config.services.prometheus.port}"
                    "prometheus2:${toString config.services.prometheus.port}"
                  ];
                }
              ];
            }
            {
              job_name = "prometheus";
              static_configs = [
                {
                  targets = [
                    "global1:${toString config.services.prometheus.port}"
                    "global2:${toString config.services.prometheus.port}"
                  ];
                }
              ];
            }
          ];
        };
      };

    global2 =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";

          scrapeConfigs = [
            {
              job_name = "federate";
              honor_labels = true;
              metrics_path = "/federate";

              params = {
                "match[]" = [
                  "{job=\"node\"}"
                  "{job=\"prometheus\"}"
                ];
              };

              static_configs = [
                {
                  targets = [
                    "prometheus1:${toString config.services.prometheus.port}"
                    "prometheus2:${toString config.services.prometheus.port}"
                  ];
                }
              ];
            }
            {
              job_name = "prometheus";
              static_configs = [
                {
                  targets = [
                    "global1:${toString config.services.prometheus.port}"
                    "global2:${toString config.services.prometheus.port}"
                  ];
                }
              ];
            }
          ];
        };
      };

    prometheus1 =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";

          scrapeConfigs = [
            {
              job_name = "node";
              static_configs = [
                { targets = [ "node1:${toString config.services.prometheus.exporters.node.port}" ]; }
              ];
            }
            {
              job_name = "prometheus";
              static_configs = [ { targets = [ "prometheus1:${toString config.services.prometheus.port}" ]; } ];
            }
          ];
        };
      };

    prometheus2 =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";

          scrapeConfigs = [
            {
              job_name = "node";
              static_configs = [
                { targets = [ "node2:${toString config.services.prometheus.exporters.node.port}" ]; }
              ];
            }
            {
              job_name = "prometheus";
              static_configs = [ { targets = [ "prometheus2:${toString config.services.prometheus.port}" ]; } ];
            }
          ];
        };
      };

    node1 =
      { config, pkgs, ... }:
      {
        services.prometheus.exporters.node = {
          enable = true;
          openFirewall = true;
        };
      };

    node2 =
      { config, pkgs, ... }:
      {
        services.prometheus.exporters.node = {
          enable = true;
          openFirewall = true;
        };
      };
  };

  testScript = ''
    for machine in node1, node2:
      machine.wait_for_unit("prometheus-node-exporter")
      machine.wait_for_open_port(9100)

    for machine in prometheus1, prometheus2, global1, global2:
      machine.wait_for_unit("prometheus")
      machine.wait_for_open_port(9090)

    # Verify both servers got the same data from the exporter
    for machine in prometheus1, prometheus2:
      machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=count(up\{job=\"node\"\})' | "
        + "jq '.data.result[0].value[1]' | grep '\"1\"'"
      )
      machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=count(prometheus_build_info)' | "
        + "jq '.data.result[0].value[1]' | grep '\"1\"'"
      )

    for machine in global1, global2:
      machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=count(up\{job=\"node\"\})' | "
        + "jq '.data.result[0].value[1]' | grep '\"2\"'"
      )

      machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=count(prometheus_build_info)' | "
        + "jq '.data.result[0].value[1]' | grep '\"4\"'"
      )
  '';
}
