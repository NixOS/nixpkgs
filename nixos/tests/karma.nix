import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "karma";
  nodes = {
    server = { ... }: {
      services.prometheus.alertmanager = {
        enable = true;
        logLevel = "debug";
        port = 9093;
        openFirewall = true;
        configuration = {
          global = {
            resolve_timeout = "1m";
          };
          route = {
            # Root route node
            receiver = "test";
            group_by = ["..."];
            continue = false;
            group_wait = "1s";
            group_interval="15s";
            repeat_interval = "24h";
          };
          receivers = [
            {
              name = "test";
              webhook_configs = [
                {
                  url = "http://localhost:1234";
                  send_resolved = true;
                  max_alerts = 0;
                }
              ];
            }
          ];
        };
      };
      services.karma = {
        enable = true;
        openFirewall = true;
        settings = {
          listen = {
            address = "0.0.0.0";
            port = 8081;
          };
          alertmanager = {
            servers = [
              {
                name = "alertmanager";
                uri = "https://127.0.0.1:9093";
              }
            ];
          };
          karma.name = "test-dashboard";
          log.config = true;
          log.requests = true;
          log.timestamp = true;
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("Wait for server to come up"):

      server.wait_for_unit("alertmanager.service")
      server.wait_for_unit("karma.service")

      server.sleep(5) # wait for both services to settle

      server.wait_for_open_port(9093)
      server.wait_for_open_port(8081)

    with subtest("Test alertmanager readiness"):
      server.succeed("curl -s http://127.0.0.1:9093/-/ready")

      # Karma only starts serving the dashboard once it has established connectivity to all alertmanagers in its config
      # Therefore, this will fail if karma isn't able to reach alertmanager
      server.succeed("curl -s http://127.0.0.1:8081")

    server.shutdown()
  '';
})
