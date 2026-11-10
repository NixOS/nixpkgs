{ pkgs, ... }:
{
  name = "git-pages-modular-service";

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];

    system.services.git-pages = {
      imports = [ pkgs.git-pages.services.default ];
      git-pages = {
        settings.server = {
          pages = "tcp/:3000";
          caddy = "tcp/:3001";
          metrics = "tcp/:3002";
        };
      };
      systemd.service.environment.PAGES_INSECURE = "1";
    };

    services.caddy = {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        {
            admin off
            persist_config off
            auto_https disable_redirects
            on_demand_tls {
                permission http http://localhost:3001
            }
        }
        https://, http:// {
          tls {
              on_demand
          }
          reverse_proxy http://localhost:3000
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  testScript =
    let
      testSite = pkgs.runCommand "git-pages-testsite.tar" { } ''
        echo It works! > index.html
        tar cvf $out index.html
      '';
    in
    ''
      start_all()

      machine.wait_for_unit("caddy.service")
      machine.wait_for_open_port(80)
      machine.wait_for_unit("git-pages.service")
      machine.wait_for_open_port(3001)
      machine.wait_for_open_port(3002)
      machine.fail("curl -f http://localhost/.git-pages/health")
      machine.succeed("curl -f http://localhost/ -X PUT --data-binary @${testSite} --header 'Content-Type: application/x-tar'")
      machine.wait_until_succeeds("test -f /var/lib/git-pages/data/site/localhost/.index")
      machine.succeed("curl -f http://localhost/.git-pages/health")
      machine.succeed("curl -f http://localhost/ | grep -F 'It works!'")
      machine.succeed("curl -f http://localhost:3002/metrics")
    '';
}
