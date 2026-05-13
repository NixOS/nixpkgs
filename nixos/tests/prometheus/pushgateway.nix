{ pkgs, ... }:

{
  name = "prometheus-pushgateway";

  nodes = {
    prometheus =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";

          scrapeConfigs = [
            {
              job_name = "pushgateway";
              static_configs = [ { targets = [ "pushgateway:9091" ]; } ];
            }
          ];
        };
      };

    pushgateway =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 9091 ];

        services.prometheus.pushgateway = {
          enable = true;
        };
      };

    client = { config, pkgs, ... }: { };
  };

  testScript = ''
    pushgateway.wait_for_unit("pushgateway")
    pushgateway.wait_for_open_port(9091)
    pushgateway.wait_until_succeeds("curl -s http://127.0.0.1:9091/-/ready")
    pushgateway.wait_until_succeeds("journalctl -o cat -u pushgateway.service | grep 'version=${pkgs.prometheus-pushgateway.version}'")

    prometheus.wait_for_unit("prometheus")
    prometheus.wait_for_open_port(9090)

    prometheus.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=count(up\{job=\"pushgateway\"\})' | "
      + "jq '.data.result[0].value[1]' | grep '\"1\"'"
    )

    prometheus.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=sum(pushgateway_build_info)%20by%20(version)' | "
      + "jq '.data.result[0].metric.version' | grep '\"${pkgs.prometheus-pushgateway.version}\"'"
    )

    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")

    # Add a metric and check in Prometheus
    client.wait_until_succeeds(
      "echo 'some_metric 3.14' | curl --data-binary @- http://pushgateway:9091/metrics/job/some_job"
    )

    prometheus.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=some_metric' | "
      + "jq '.data.result[0].value[1]' | grep '\"3.14\"'"
    )

    prometheus.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=absent(some_metric)' | "
      + "jq '.data.result[0].value[1]' | grep 'null'"
    )

    # Delete the metric, check not in Prometheus
    client.wait_until_succeeds(
      "curl -X DELETE http://pushgateway:9091/metrics/job/some_job"
    )

    prometheus.wait_until_fails(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=some_metric' | "
      + "jq '.data.result[0].value[1]' | grep '\"3.14\"'"
    )

    prometheus.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=absent(some_metric)' | "
      + "jq '.data.result[0].value[1]' | grep '\"1\"'"
    )

    pushgateway.log(pushgateway.succeed("systemd-analyze security pushgateway.service | grep -v '✓'"))
  '';
}
