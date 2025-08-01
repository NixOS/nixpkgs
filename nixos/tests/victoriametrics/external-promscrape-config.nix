{ lib, pkgs, ... }:
let
  nodeExporterPort = 9100;
  promscrapeConfig = {
    global = {
      scrape_interval = "2s";
    };
    scrape_configs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "node:${toString nodeExporterPort}"
            ];
          }
        ];
      }
    ];
  };
  settingsFormat = pkgs.formats.yaml { };
  promscrapeConfigYaml = settingsFormat.generate "prometheusConfig.yaml" promscrapeConfig;
in
{
  name = "victoriametrics-external-promscrape-config";
  meta = with lib.maintainers; {
    maintainers = [
      ryan4yin
    ];
  };

  nodes = {
    victoriametrics =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
        networking.firewall.allowedTCPPorts = [ 8428 ];
        services.victoriametrics = {
          enable = true;
          extraOptions = [
            "-promscrape.config=${toString promscrapeConfigYaml}"
          ];
        };
      };

    node = {
      services.prometheus.exporters.node = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  testScript = ''
    node.wait_for_unit("prometheus-node-exporter")
    node.wait_for_open_port(${toString nodeExporterPort})

    victoriametrics.wait_for_unit("victoriametrics")
    victoriametrics.wait_for_open_port(8428)


    promscrape_config = victoriametrics.succeed("journalctl -u victoriametrics -o cat | grep 'promscrape.config'")
    assert '${toString promscrapeConfigYaml}' in promscrape_config

    victoriametrics.wait_until_succeeds(
      "curl -sf 'http://localhost:8428/api/v1/query?query=node_exporter_build_info\{instance=\"node:9100\"\}' | "
      + "jq '.data.result[0].value[1]' | grep '\"1\"'"
    )
  '';
}
