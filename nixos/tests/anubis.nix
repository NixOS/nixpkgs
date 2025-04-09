{ lib, ... }:
{
  name = "anubis";
  meta.maintainers = [ lib.maintainers.soopyc ];

  nodes.machine =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.anubis.instances = {
        "".settings.TARGET = "http://localhost:8080";

        "tcp" = {
          user = "anubis-tcp";
          group = "anubis-tcp";
          settings = {
            TARGET = "http://localhost:8080";
            BIND = ":9000";
            BIND_NETWORK = "tcp";
            METRICS_BIND = ":9001";
            METRICS_BIND_NETWORK = "tcp";
          };
        };

        "unix-upstream" = {
          group = "nginx";
          settings.TARGET = "unix:///run/nginx/nginx.sock";
        };
      };

      # support
      users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."basic.localhost".locations = {
          "/".proxyPass = "http://unix:${config.services.anubis.instances."".settings.BIND}";
          "/metrics".proxyPass = "http://unix:${config.services.anubis.instances."".settings.METRICS_BIND}";
        };

        virtualHosts."tcp.localhost".locations = {
          "/".proxyPass = "http://localhost:9000";
          "/metrics".proxyPass = "http://localhost:9001";
        };

        virtualHosts."unix.localhost".locations = {
          "/".proxyPass = "http://unix:${config.services.anubis.instances.unix-upstream.settings.BIND}";
        };

        # emulate an upstream with nginx, listening on tcp and unix sockets.
        virtualHosts."upstream.localhost" = {
          default = true; # make nginx match this vhost for `localhost`
          listen = [
            { addr = "unix:/run/nginx/nginx.sock"; }
            {
              addr = "localhost";
              port = 8080;
            }
          ];
          locations."/" = {
            tryFiles = "$uri $uri/index.html =404";
            root = pkgs.runCommand "anubis-test-upstream" { } ''
              mkdir $out
              echo "it works" >> $out/index.html
            '';
          };
        };
      };
    };

  testScript = ''
    for unit in ["nginx", "anubis", "anubis-tcp", "anubis-unix-upstream"]:
      machine.wait_for_unit(unit + ".service")

    for port in [9000, 9001]:
      machine.wait_for_open_port(port)

    for instance in ["anubis", "anubis-unix-upstream"]:
      machine.wait_for_open_unix_socket(f"/run/anubis/{instance}.sock")
      machine.wait_for_open_unix_socket(f"/run/anubis/{instance}-metrics.sock")

    # Default unix socket mode
    machine.succeed('curl -f http://basic.localhost | grep "it works"')
    machine.succeed('curl -f http://basic.localhost -H "User-Agent: Mozilla" | grep anubis')
    machine.succeed('curl -f http://basic.localhost/metrics | grep anubis_challenges_issued')
    machine.succeed('curl -f -X POST http://basic.localhost/.within.website/x/cmd/anubis/api/make-challenge | grep challenge')

    # TCP mode
    machine.succeed('curl -f http://tcp.localhost -H "User-Agent: Mozilla" | grep anubis')
    machine.succeed('curl -f http://tcp.localhost/metrics | grep anubis_challenges_issued')

    # Upstream is a unix socket mode
    machine.succeed('curl -f http://unix.localhost/index.html | grep "it works"')
  '';
}
