import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "nginx-status-page";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ h7x4 ];
    };

    nodes = {
      webserver =
        { ... }:
        {
          virtualisation.vlans = [ 1 ];

          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
          };

          systemd.network.networks."01-eth1" = {
            name = "eth1";
            networkConfig.Address = "10.0.0.1/24";
          };

          services.nginx = {
            enable = true;
            statusPage = true;
            virtualHosts."localhost".locations."/index.html".return = "200 'hello world\n'";
          };

          environment.systemPackages = with pkgs; [ curl ];
        };

      client =
        { ... }:
        {
          virtualisation.vlans = [ 1 ];

          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
          };

          systemd.network.networks."01-eth1" = {
            name = "eth1";
            networkConfig.Address = "10.0.0.2/24";
          };

          environment.systemPackages = with pkgs; [ curl ];
        };
    };

    testScript =
      { nodes, ... }:
      ''
        start_all()

        webserver.wait_for_unit("nginx")
        webserver.wait_for_open_port(80)

        def expect_http_code(node, code, url):
            http_code = node.succeed(f"curl -w '%{{http_code}}' '{url}'")
            assert http_code.split("\n")[-1].strip() == code, \
              f"expected {code} but got following response:\n{http_code}"

        with subtest("localhost can access status page"):
            expect_http_code(webserver, "200", "http://localhost/nginx_status")

        with subtest("localhost can access other page"):
            expect_http_code(webserver, "200", "http://localhost/index.html")

        with subtest("client can not access status page"):
            expect_http_code(client, "403", "http://10.0.0.1/nginx_status")

        with subtest("client can access other page"):
            expect_http_code(client, "200", "http://10.0.0.1/index.html")
      '';
  }
)
