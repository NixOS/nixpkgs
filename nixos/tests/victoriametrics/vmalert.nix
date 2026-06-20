# Primarily reference the implementation of <nixos/tests/prometheus/alertmanager.nix>
{ lib, pkgs, ... }:
{
  name = "victoriametrics-vmalert";
  meta = with lib.maintainers; {
    maintainers = [
      yorickvp
      ryan4yin
    ];
  };

  nodes = {
    victoriametrics =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
        networking.firewall.allowedTCPPorts = [ 8428 ];
        services.victoriametrics = {
          enable = true;
          prometheusConfig = {
            global = {
              scrape_interval = "2s";
            };
            scrape_configs = [
              {
                job_name = "alertmanager";
                static_configs = [
                  {
                    targets = [
                      "alertmanager:${toString config.services.prometheus.alertmanager.port}"
                    ];
                  }
                ];
              }
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

        services.vmalert.instances."" = {
          enable = true;
          settings = {
            "datasource.url" = "http://localhost:8428"; # victoriametrics' api
            "notifier.url" = [
              "http://alertmanager:${toString config.services.prometheus.alertmanager.port}"
            ]; # alertmanager's api
            rule = [
              (pkgs.writeText "instance-down.yml" ''
                groups:
                  - name: test
                    rules:
                      - alert: InstanceDown
                        expr: up == 0
                        for: 5s
                        labels:
                          severity: page
                        annotations:
                          summary: "Instance {{ $labels.instance }} down"
              '')
            ];
          };
        };
      };

    alertmanager = {
      services.prometheus.alertmanager = {
        enable = true;
        openFirewall = true;

        configuration = {
          global = {
            resolve_timeout = "1m";
          };

          route = {
            # Root route node
            receiver = "test";
            group_by = [ "..." ];
            continue = false;
            group_wait = "1s";
            group_interval = "15s";
            repeat_interval = "24h";
          };

          receivers = [
            {
              name = "test";
              webhook_configs = [
                {
                  url = "http://logger:6725";
                  send_resolved = true;
                  max_alerts = 0;
                }
              ];
            }
          ];
        };
      };
    };

    logger = {
      networking.firewall.allowedTCPPorts = [ 6725 ];

      services.prometheus.alertmanagerWebhookLogger.enable = true;
    };
  };

  testScript = ''
    alertmanager.wait_for_unit("alertmanager")
    alertmanager.wait_for_open_port(9093)
    alertmanager.wait_until_succeeds("curl -s http://127.0.0.1:9093/-/ready")

    logger.wait_for_unit("alertmanager-webhook-logger")
    logger.wait_for_open_port(6725)

    victoriametrics.wait_for_unit("victoriametrics")
    victoriametrics.wait_for_unit("vmalert")
    victoriametrics.wait_for_open_port(8428)

    victoriametrics.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:8428/api/v1/query?query=count(up\{job=\"alertmanager\"\}==1)' | "
      + "jq '.data.result[0].value[1]' | grep '\"1\"'"
    )

    victoriametrics.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:8428/api/v1/query?query=sum(alertmanager_build_info)%20by%20(version)' | "
      + "jq '.data.result[0].metric.version' | grep '\"${pkgs.prometheus-alertmanager.version}\"'"
    )

    victoriametrics.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:8428/api/v1/query?query=count(up\{job=\"node\"\}!=1)' | "
      + "jq '.data.result[0].value[1]' | grep '\"1\"'"
    )

    victoriametrics.wait_until_succeeds(
      "curl -sf 'http://127.0.0.1:8428/api/v1/query?query=alertmanager_notifications_total\{integration=\"webhook\"\}' | "
      + "jq '.data.result[0].value[1]' | grep -v '\"0\"'"
    )

    logger.wait_until_succeeds(
      "journalctl -o cat -u alertmanager-webhook-logger.service | grep '\"alertname\":\"InstanceDown\"'"
    )

    logger.log(logger.succeed("systemd-analyze security alertmanager-webhook-logger.service | grep -v '✓'"))

    alertmanager.log(alertmanager.succeed("systemd-analyze security alertmanager.service | grep -v '✓'"))
  '';
}
