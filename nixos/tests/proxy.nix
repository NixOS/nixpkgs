import ./make-test-python.nix ({ pkgs, ...} :

let

  backend =
    { pkgs, ... }:

    { services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.nix.doc}/share/doc/nix/manual";
      networking.firewall.allowedTCPPorts = [ 80 ];
    };

in

{
  name = "proxy";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes =
    { proxy =
        { nodes, ... }:

        { services.httpd.enable = true;
          services.httpd.adminAddr = "bar@example.org";
          services.httpd.extraModules = [ "proxy_balancer" "lbmethod_byrequests" ];

          services.httpd.extraConfig =
            ''
              ExtendedStatus on

              <Location /server-status>
                Require all granted
                SetHandler server-status
              </Location>

              <Proxy balancer://cluster>
                Require all granted
                BalancerMember http://${nodes.backend1.config.networking.hostName} retry=0
                BalancerMember http://${nodes.backend2.config.networking.hostName} retry=0
              </Proxy>

              ProxyStatus       full
              ProxyPass         /server-status !
              ProxyPass         /       balancer://cluster/
              ProxyPassReverse  /       balancer://cluster/

              # For testing; don't want to wait forever for dead backend servers.
              ProxyTimeout      5
            '';

          networking.firewall.allowedTCPPorts = [ 80 ];
        };

      backend1 = backend;
      backend2 = backend;

      client = { ... }: { };
    };

  testScript =
    ''
      start_all()

      with subtest("Wait for units to start"):
          proxy.wait_for_unit("httpd")
          backend1.wait_for_unit("httpd")
          backend2.wait_for_unit("httpd")
          client.wait_for_unit("network.target")

      with subtest("With the back-end up, the proxy should work"):
          client.succeed("curl --fail http://proxy/")
          client.succeed("curl --fail http://proxy/server-status")

      with subtest("The proxy should still work with the first back-end blocked off"):
          backend1.block()
          client.succeed("curl --fail http://proxy/")
          client.succeed("curl --fail http://proxy/")

      with subtest("The proxy should fail when the second back-end is blocked"):
          backend2.block()
          client.fail("curl --fail http://proxy/")

      with subtest("The proxy should start working again after second back-end comes back"):
          backend2.unblock()
          client.succeed("curl --fail http://proxy/")
    '';
})
