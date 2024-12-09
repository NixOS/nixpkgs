import ../make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "prometheus-config-reload";

  nodes = {
    prometheus = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];

      networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

      services.prometheus = {
        enable = true;
        enableReload = true;
        globalConfig.scrape_interval = "2s";
        scrapeConfigs = [
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = [
                  "prometheus:${toString config.services.prometheus.port}"
                ];
              }
            ];
          }
        ];
      };

      specialisation = {
        "prometheus-config-change" = {
          configuration = {
            environment.systemPackages = [ pkgs.yq ];

            # This configuration just adds a new prometheus job
            # to scrape the node_exporter metrics of the s3 machine.
            services.prometheus = {
              scrapeConfigs = [
                {
                  job_name = "node";
                  static_configs = [
                    {
                      targets = [ "node:${toString config.services.prometheus.exporters.node.port}" ];
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };

  testScript = ''
    prometheus.wait_for_unit("prometheus")
    prometheus.wait_for_open_port(9090)

    # Check if switching to a NixOS configuration that changes the prometheus
    # configuration reloads (instead of restarts) prometheus before the switch
    # finishes successfully:
    with subtest("config change reloads prometheus"):
      import json
      # We check if prometheus has finished reloading by looking for the message
      # "Completed loading of configuration file" in the journal between the start
      # and finish of switching to the new NixOS configuration.
      #
      # To mark the start we record the journal cursor before starting the switch:
      cursor_before_switching = json.loads(
          prometheus.succeed("journalctl -n1 -o json --output-fields=__CURSOR")
      )["__CURSOR"]

      # Now we switch:
      prometheus_config_change = prometheus.succeed(
          "readlink /run/current-system/specialisation/prometheus-config-change"
      ).strip()
      prometheus.succeed(prometheus_config_change + "/bin/switch-to-configuration test")

      # Next we retrieve all logs since the start of switching:
      logs_after_starting_switching = prometheus.succeed(
          """
            journalctl --after-cursor='{cursor_before_switching}' -o json --output-fields=MESSAGE
          """.format(
              cursor_before_switching=cursor_before_switching
          )
      )

      # Finally we check if the message "Completed loading of configuration file"
      # occurs before the "finished switching to system configuration" message:
      finished_switching_msg = (
          "finished switching to system configuration " + prometheus_config_change
      )
      reloaded_before_switching_finished = False
      finished_switching = False
      for log_line in logs_after_starting_switching.split("\n"):
          msg = json.loads(log_line)["MESSAGE"]
          if "Completed loading of configuration file" in msg:
              reloaded_before_switching_finished = True
          if msg == finished_switching_msg:
              finished_switching = True
              break

      assert reloaded_before_switching_finished
      assert finished_switching

      # Check if the reloaded config includes the new node job:
      prometheus.succeed(
        """
          curl -sf http://127.0.0.1:9090/api/v1/status/config \
            | jq -r .data.yaml \
            | yq '.scrape_configs | any(.job_name == "node")' \
            | grep true
        """
      )
  '';
})
