import ./make-test-python.nix ({ lib, ... }:
{
  name = "ntpd-rs";

  meta = {
    maintainers = with lib.maintainers; [ fpletz ];
  };

  nodes = {
    client = {
      services.ntpd-rs = {
        enable = true;
        metrics.enable = true;
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
      networking.firewall.allowedUDPPorts = [ 123 ];
      services.ntpd-rs = {
        enable = true;
        metrics.enable = true;
        settings = {
          server = [
            { listen = "[::]:123"; }
          ];
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    start_all()

    for machine in (server, client):
      machine.wait_for_unit('multi-user.target')
      machine.succeed('systemctl is-active ntpd-rs.service')
      machine.succeed('systemctl is-active ntpd-rs-metrics.service')
      machine.succeed('curl http://localhost:9975/metrics | grep ntp_uptime_seconds')
  '';
})
