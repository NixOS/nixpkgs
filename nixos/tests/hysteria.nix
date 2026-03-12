{ lib, pkgs, ... }:
{
  name = "hysteria";
  meta.maintainers = with pkgs.lib.maintainers; [ Guanran928 ];

  nodes.client = {
    networking = {
      useDHCP = false;
      interfaces.eth1.ipv4.addresses = lib.singleton {
        address = "10.0.0.1";
        prefixLength = 24;
      };
    };

    services.hysteria = {
      enable = true;
      mode = "client";
      settings = {
        server = "10.0.0.2";
        auth = "hunter2";
        http.listen = "127.0.0.1:8080";
        tls.insecure = true;
      };
    };
  };

  nodes.server = {
    networking = {
      useDHCP = false;
      firewall.allowedUDPPorts = [ 443 ];
      interfaces.eth1.ipv4.addresses = lib.singleton {
        address = "10.0.0.2";
        prefixLength = 24;
      };
    };

    services.hysteria = {
      enable = true;
      mode = "server";
      settings = {
        tls = {
          cert = ./common/acme/server/acme.test.cert.pem;
          key = ./common/acme/server/acme.test.key.pem;
          sniGuard = "disable";
        };

        auth = {
          type = "password";
          password = "hunter2";
        };

        masquerade = {
          type = "proxy";
          proxy = {
            url = "https://news.ycombinator.com/";
            rewriteHost = true;
          };
        };
      };
    };
  };

  nodes.target = {
    networking = {
      useDHCP = false;
      firewall.allowedTCPPorts = [ 80 ];
      interfaces.eth1.ipv4.addresses = lib.singleton {
        address = "10.0.0.3";
        prefixLength = 24;
      };
    };

    services.nginx = {
      enable = true;
      statusPage = true;
    };
  };

  testScript = /* python */ ''
    # Wait until it starts
    target.wait_for_unit("nginx.service")
    target.wait_for_open_port(80)

    server.wait_for_unit("hysteria.service")

    client.wait_for_unit("hysteria.service")
    client.wait_for_open_port(8080)

    # Proxy
    client.succeed("curl --fail --max-time 10 --proxy http://localhost:8080 http://10.0.0.3:80")
  '';
}
