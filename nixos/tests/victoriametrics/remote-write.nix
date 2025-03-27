# Primarily reference the implementation of <nixos/tests/prometheus/remote-write.nix>
import ../make-test-python.nix (
  {
    lib,
    pkgs,
    ...
  }:
  let
    username = "vmtest";
    password = "fsddfy8233rb"; # random string
    passwordFile = pkgs.writeText "password-file" password;
  in
  {
    name = "victoriametrics-remote-write";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        yorickvp
        ryan4yin
      ];
    };

    nodes = {
      victoriametrics =
        {
          config,
          pkgs,
          ...
        }:
        {
          environment.systemPackages = [ pkgs.jq ];
          networking.firewall.allowedTCPPorts = [ 8428 ];
          services.victoriametrics = {
            enable = true;
            extraOptions = [
              "-httpAuth.username=${username}"
              "-httpAuth.password=file://${toString passwordFile}"
            ];
          };
        };

      vmagent =
        {
          config,
          pkgs,
          ...
        }:
        {
          environment.systemPackages = [ pkgs.jq ];
          services.vmagent = {
            enable = true;
            remoteWrite = {
              url = "http://victoriametrics:8428/api/v1/write";
              basicAuthUsername = username;
              basicAuthPasswordFile = toString passwordFile;
            };

            prometheusConfig = {
              global = {
                scrape_interval = "2s";
              };
              scrape_configs = [
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
        };

      node =
        { ... }:
        {
          services.prometheus.exporters.node = {
            enable = true;
            openFirewall = true;
          };
        };
    };

    testScript = ''
      node.wait_for_unit("prometheus-node-exporter")
      node.wait_for_open_port(9100)

      victoriametrics.wait_for_unit("victoriametrics")
      victoriametrics.wait_for_open_port(8428)

      vmagent.wait_for_unit("vmagent")

      # check remote write
      victoriametrics.wait_until_succeeds(
        "curl --user '${username}:${password}' -sf 'http://localhost:8428/api/v1/query?query=node_exporter_build_info\{instance=\"node:9100\"\}' | "
        + "jq '.data.result[0].value[1]' | grep '\"1\"'"
      )
    '';
  }
)
