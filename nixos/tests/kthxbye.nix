import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "kthxbye";

    meta = with lib.maintainers; {
      maintainers = [ nukaduka ];
    };

    nodes.server =
      { ... }:
      {
        environment.systemPackages = with pkgs; [ prometheus-alertmanager ];
        services.prometheus = {
          enable = true;

          globalConfig = {
            scrape_interval = "5s";
            scrape_timeout = "5s";
            evaluation_interval = "5s";
          };

          scrapeConfigs = [
            {
              job_name = "prometheus";
              scrape_interval = "5s";
              static_configs = [
                {
                  targets = [ "localhost:9090" ];
                }
              ];
            }
          ];

          rules = [
            ''
              groups:
                - name: test
                  rules:
                    - alert: node_up
                      expr: up != 0
                      for: 5s
                      labels:
                        severity: bottom of the barrel
                      annotations:
                        summary: node is fine
            ''
          ];

          alertmanagers = [
            {
              static_configs = [
                {
                  targets = [
                    "localhost:9093"
                  ];
                }
              ];
            }
          ];

          alertmanager = {
            enable = true;
            openFirewall = true;
            configuration.route = {
              receiver = "test";
              group_wait = "5s";
              group_interval = "5s";
              group_by = [ "..." ];
            };
            configuration.receivers = [
              {
                name = "test";
                webhook_configs = [
                  {
                    url = "http://localhost:1234";
                  }
                ];
              }
            ];
          };
        };

        services.kthxbye = {
          enable = true;
          openFirewall = true;
          extendIfExpiringIn = "30s";
          logJSON = true;
          maxDuration = "15m";
          interval = "5s";
        };
      };

    testScript = ''
      with subtest("start the server"):
        start_all()
        server.wait_for_unit("prometheus.service")
        server.wait_for_unit("alertmanager.service")
        server.wait_for_unit("kthxbye.service")

        server.sleep(2) # wait for units to settle
        server.systemctl("restart kthxbye.service") # make sure kthxbye comes up after alertmanager
        server.sleep(2)

      with subtest("set up test silence which expires in 20s"):
        server.succeed('amtool --alertmanager.url "http://localhost:9093" silence add alertname="node_up" -a "nixosTest" -d "20s" -c "ACK! this server is fine!!"')

      with subtest("wait for 21 seconds and check if the silence is still active"):
        server.sleep(21)
        server.systemctl("status kthxbye.service")
        server.succeed("amtool --alertmanager.url 'http://localhost:9093' silence | grep 'ACK'")
    '';
  }
)
