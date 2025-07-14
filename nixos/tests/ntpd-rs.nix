{ lib, ... }:
{
  name = "ntpd-rs";

  meta = {
    maintainers = with lib.maintainers; [ fpletz ];
  };

  nodes = {
    client = {
      services.ntpd-rs = {
        enable = true;
        metrics.enable = false;
        useNetworkingTimeServers = false;
        settings = {
          source = [
            {
              mode = "server";
              address = "server";
            }
          ];
          synchronization = {
            minimum-agreeing-sources = 1;
          };
        };
      };
    };
    server = {
      networking.firewall = {
        allowedTCPPorts = [
          9975
        ];
        allowedUDPPorts = [
          123
        ];
      };

      services.ntpd-rs = {
        enable = true;
        metrics.enable = true;
        settings = {
          observability = {
            metrics-exporter-listen = "[::]:9975";
          };
          server = [
            { listen = "[::]:123"; }
          ];
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      for machine in (server, client):
        machine.wait_for_unit('multi-user.target')
        machine.succeed('systemctl is-active ntpd-rs.service')

      client.fail('systemctl is-active ntpd-rs-metrics.service')
      server.succeed('systemctl is-active ntpd-rs-metrics.service')

      server.wait_for_open_port(9975)
      client.succeed('curl http://server:9975/metrics | grep ntp_uptime_seconds')
      server.fail('curl --fail --connect-timeout 2 http://client:9975/metrics | grep ntp_uptime_seconds')

      client.succeed("ntp-ctl status | grep server:123")
      server.succeed("ntp-ctl status | grep '\[::\]:123'")

      client.succeed("grep '^mode = \"server\"' $(systemctl status ntpd-rs | grep -oE '/nix/store[^ ]*ntpd-rs.toml')")
      server.succeed("grep '^mode = \"pool\"' $(systemctl status ntpd-rs | grep -oE '/nix/store[^ ]*ntpd-rs.toml')")
    '';
}
