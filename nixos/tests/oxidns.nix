{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
  },
}:
pkgs.testers.runNixOSTest {
  name = "oxidns-module";

  nodes.machine = {
    services.oxidns = {
      enable = true;

      settings = {
        log.level = "info";
        plugins = [
          {
            tag = "test-forward";
            type = "forward";
            args = {
              concurrent = 2;
              response_selection = "prefer_positive";
              upstreams = [
                { addr = "udp://8.8.8.8:53"; }
                { addr = "udp://1.1.1.1:53"; }
              ];
            };
          }
          {
            tag = "udp-in";
            type = "udp_server";
            args = {
              entry = "test-forward";
              listen = "127.0.0.1:5353";
            };
          }
        ];
      };
    };

    networking.firewall.allowedUDPPorts = [ 5353 ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("oxidns.service")
    machine.succeed("systemctl is-active oxidns.service")

    machine.succeed("${pkgs.dig}/bin/dig @127.0.0.1 -p 5353 example.com A")

    machine.stop_job("oxidns.service")
    machine.wait_until_fails("systemctl is-active oxidns.service")
  '';
}
