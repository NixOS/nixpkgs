# This is a simple distributed test involving a topology with two
# separate virtual networks - the "inside" and the "outside" - with a
# client on the inside network, a server on the outside network, and a
# router connected to both that performs Network Address Translation
# for the client.
import ./make-test-python.nix ({ pkgs, lib, withFirewall, nftables ? false, ... }:
  let
    unit = if nftables then "nftables" else (if withFirewall then "firewall" else "nat");

    routerBase =
      lib.mkMerge [
        { virtualisation.vlans = [ 2 1 ];
          networking.firewall.enable = withFirewall;
          networking.firewall.filterForward = nftables;
          networking.nftables.enable = nftables;
          networking.nat.internalIPs = [ "192.168.1.0/24" ];
          networking.nat.externalInterface = "eth1";
        }
      ];
  in
  {
    name = "nat" + (lib.optionalString nftables "Nftables")
                 + (if withFirewall then "WithFirewall" else "Standalone");
    meta = with pkgs.lib.maintainers; {
      maintainers = [ rob ];
    };

    nodes =
      { client =
          { pkgs, nodes, ... }:
          lib.mkMerge [
            { virtualisation.vlans = [ 1 ];
              networking.defaultGateway =
                (pkgs.lib.head nodes.router.networking.interfaces.eth2.ipv4.addresses).address;
              networking.nftables.enable = nftables;
            }
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
        routerDummyNoNatClosure = nodes.routerDummyNoNat.system.build.toplevel;
        routerClosure = nodes.router.system.build.toplevel;
      in ''
        client.start()
        router.start()
        server.start()

        # The router should have access to the server.
        server.wait_for_unit("network.target")
        server.wait_for_unit("httpd")
        router.wait_for_unit("network.target")
        router.succeed("curl -4 --fail http://server/ >&2")

        # The client should be also able to connect via the NAT router.
        router.wait_for_unit("${unit}")
        client.wait_for_unit("network.target")
        client.succeed("curl --fail http://server/ >&2")
        client.succeed("ping -4 -c 1 server >&2")

        # Test whether passive FTP works.
        server.wait_for_unit("vsftpd")
        server.succeed("echo Hello World > /home/ftp/foo.txt")
        client.succeed("curl -v ftp://server/foo.txt >&2")

        # Test whether active FTP works.
        client.fail("curl -v -P - ftp://server/foo.txt >&2")

        # Test ICMP.
        client.succeed("ping -4 -c 1 router >&2")
        router.succeed("ping -4 -c 1 client >&2")

        # If we turn off NAT, the client shouldn't be able to reach the server.
        router.succeed(
            "${routerDummyNoNatClosure}/bin/switch-to-configuration test 2>&1"
        )
        client.fail("curl -4 --fail --connect-timeout 5 http://server/ >&2")
        client.fail("ping -4 -c 1 server >&2")

        # And make sure that reloading the NAT job works.
        router.succeed(
            "${routerClosure}/bin/switch-to-configuration test 2>&1"
        )
        # FIXME: this should not be necessary, but nat.service is not started because
        #        network.target is not triggered
        #        (https://github.com/NixOS/nixpkgs/issues/16230#issuecomment-226408359)
        ${lib.optionalString (!withFirewall && !nftables) ''
          router.succeed("systemctl start nat.service")
        ''}
        client.succeed("curl -4 --fail http://server/ >&2")
        client.succeed("ping -4 -c 1 server >&2")
      '';
})
