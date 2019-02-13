# This is a simple distributed test involving a topology with two
# separate virtual networks - the "inside" and the "outside" - with a
# client on the inside network, a server on the outside network, and a
# router connected to both that performs Network Address Translation
# for the client.
import ./make-test.nix ({ pkgs, lib, withFirewall, withConntrackHelpers ? false, ... }:
  let
    unit = if withFirewall then "firewall" else "nat";

    routerBase =
      lib.mkMerge [
        { virtualisation.vlans = [ 2 1 ];
          networking.firewall.enable = withFirewall;
          networking.nat.internalIPs = [ "192.168.1.0/24" ];
          networking.nat.externalInterface = "eth1";
        }
        (lib.optionalAttrs withConntrackHelpers {
          networking.firewall.connectionTrackingModules = [ "ftp" ];
          networking.firewall.autoLoadConntrackHelpers = true;
        })
      ];
  in
  {
    name = "nat" + (if withFirewall then "WithFirewall" else "Standalone")
                 + (lib.optionalString withConntrackHelpers "withConntrackHelpers");
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ eelco chaoflow rob ];
    };

    nodes =
      { client =
          { pkgs, nodes, ... }:
          lib.mkMerge [
            { virtualisation.vlans = [ 1 ];
              networking.defaultGateway =
                (pkgs.lib.head nodes.router.config.networking.interfaces.eth2.ipv4.addresses).address;
            }
            (lib.optionalAttrs withConntrackHelpers {
              networking.firewall.connectionTrackingModules = [ "ftp" ];
              networking.firewall.autoLoadConntrackHelpers = true;
            })
          ];

        router =
        { ... }: lib.mkMerge [
          routerBase
          { networking.nat.enable = true; }
        ];

        routerDummyNoNat =
        { ... }: lib.mkMerge [
          routerBase
          { networking.nat.enable = false; }
        ];

        server =
          { ... }:
          { virtualisation.vlans = [ 2 ];
            networking.firewall.enable = false;
            services.httpd.enable = true;
            services.httpd.adminAddr = "foo@example.org";
            services.vsftpd.enable = true;
            services.vsftpd.anonymousUser = true;
          };
      };

    testScript =
      { nodes, ... }: let
        routerDummyNoNatClosure = nodes.routerDummyNoNat.config.system.build.toplevel;
        routerClosure = nodes.router.config.system.build.toplevel;
      in ''
        $client->start;
        $router->start;
        $server->start;

        # The router should have access to the server.
        $server->waitForUnit("network.target");
        $server->waitForUnit("httpd");
        $router->waitForUnit("network.target");
        $router->succeed("curl --fail http://server/ >&2");

        # The client should be also able to connect via the NAT router.
        $router->waitForUnit("${unit}");
        $client->waitForUnit("network.target");
        $client->succeed("curl --fail http://server/ >&2");
        $client->succeed("ping -c 1 server >&2");

        # Test whether passive FTP works.
        $server->waitForUnit("vsftpd");
        $server->succeed("echo Hello World > /home/ftp/foo.txt");
        $client->succeed("curl -v ftp://server/foo.txt >&2");

        # Test whether active FTP works.
        $client->${if withConntrackHelpers then "succeed" else "fail"}(
          "curl -v -P - ftp://server/foo.txt >&2");

        # Test ICMP.
        $client->succeed("ping -c 1 router >&2");
        $router->succeed("ping -c 1 client >&2");

        # If we turn off NAT, the client shouldn't be able to reach the server.
        $router->succeed("${routerDummyNoNatClosure}/bin/switch-to-configuration test 2>&1");
        $client->fail("curl --fail --connect-timeout 5 http://server/ >&2");
        $client->fail("ping -c 1 server >&2");

        # And make sure that reloading the NAT job works.
        $router->succeed("${routerClosure}/bin/switch-to-configuration test 2>&1");
        # FIXME: this should not be necessary, but nat.service is not started because
        #        network.target is not triggered
        #        (https://github.com/NixOS/nixpkgs/issues/16230#issuecomment-226408359)
        ${lib.optionalString (!withFirewall) ''
          $router->succeed("systemctl start nat.service");
        ''}
        $client->succeed("curl --fail http://server/ >&2");
        $client->succeed("ping -c 1 server >&2");
      '';
  })
