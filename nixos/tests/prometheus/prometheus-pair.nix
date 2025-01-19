import ../make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "prometheus-pair";

    nodes = {
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
                job_name = "prometheus";
                static_configs = [
                  {
                    targets = [
                      "prometheus1:${toString config.services.prometheus.port}"
                      "prometheus2:${toString config.services.prometheus.port}"
                    ];
                  }
                ];
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
                job_name = "prometheus";
                static_configs = [
                  {
                    targets = [
                      "prometheus1:${toString config.services.prometheus.port}"
                      "prometheus2:${toString config.services.prometheus.port}"
                    ];
                  }
                ];
              }
            ];
          };
        };
    };

    testScript = ''
      for machine in prometheus1, prometheus2:
        machine.wait_for_unit("prometheus")
        machine.wait_for_open_port(9090)
        machine.wait_until_succeeds("journalctl -o cat -u prometheus.service | grep 'version=${pkgs.prometheus.version}'")
        machine.wait_until_succeeds("curl -sSf http://localhost:9090/-/healthy")

      # Prometheii ready - run some queries
      for machine in prometheus1, prometheus2:
        machine.wait_until_succeeds(
          "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=prometheus_build_info\{instance=\"prometheus1:9090\",version=\"${pkgs.prometheus.version}\"\}' | "
          + "jq '.data.result[0].value[1]' | grep '\"1\"'"
        )

        machine.wait_until_succeeds(
          "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=prometheus_build_info\{instance=\"prometheus1:9090\"\}' | "
          + "jq '.data.result[0].value[1]' | grep '\"1\"'"
        )

        machine.wait_until_succeeds(
          "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=sum(prometheus_build_info)%20by%20(version)' | "
          + "jq '.data.result[0].metric.version' | grep '\"${pkgs.prometheus.version}\"'"
        )

        machine.wait_until_succeeds(
          "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=sum(prometheus_build_info)%20by%20(version)' | "
          + "jq '.data.result[0].value[1]' | grep '\"2\"'"
        )

      prometheus1.log(prometheus1.succeed("systemd-analyze security prometheus.service | grep -v '✓'"))
    '';
  }
)
