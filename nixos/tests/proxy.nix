import ./make-test.nix ({ pkgs, ...} : 

let

  backend =
    { pkgs, ... }:

    { services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
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
      startAll;

      $proxy->waitForUnit("httpd");
      $backend1->waitForUnit("httpd");
      $backend2->waitForUnit("httpd");
      $client->waitForUnit("network.target");

      # With the back-ends up, the proxy should work.
      $client->succeed("curl --fail http://proxy/");

      $client->succeed("curl --fail http://proxy/server-status");

      # Block the first back-end.
      $backend1->block;

      # The proxy should still work.
      $client->succeed("curl --fail http://proxy/");

      $client->succeed("curl --fail http://proxy/");

      # Block the second back-end.
      $backend2->block;

      # Now the proxy should fail as well.
      $client->fail("curl --fail http://proxy/");

      # But if the second back-end comes back, the proxy should start
      # working again.
      $backend2->unblock;
      $client->succeed("curl --fail http://proxy/");
    '';
})
