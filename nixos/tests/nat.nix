# This is a simple distributed test involving a topology with two
# separate virtual networks - the "inside" and the "outside" - with a
# client on the inside network, a server on the outside network, and a
# router connected to both that performs Network Address Translation
# for the client.

{ pkgs, ... }:

{

  nodes =
    { client =
        { config, pkgs, nodes, ... }:
        { virtualisation.vlans = [ 1 ];
          networking.defaultGateway =
            nodes.router.config.networking.interfaces.eth2.ipAddress;
        };

      router =
        { config, pkgs, ... }:
        { virtualisation.vlans = [ 2 1 ];
          networking.nat.enable = true;
          networking.nat.internalIPs = [ "192.168.1.0/24" ];
          networking.nat.externalInterface = "eth1";
        };

      server =
        { config, pkgs, ... }:
        { virtualisation.vlans = [ 2 ];
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          services.vsftpd.enable = true;
          services.vsftpd.anonymousUser = true;
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      # The router should have access to the server.
      $server->waitForUnit("network.target");
      $server->waitForUnit("httpd");
      $router->waitForUnit("network.target");
      $router->succeed("curl --fail http://server/ >&2");

      # The client should be also able to connect via the NAT router.
      $router->waitForUnit("nat");
      $client->waitForUnit("network.target");
      $client->succeed("curl --fail http://server/ >&2");
      $client->succeed("ping -c 1 server >&2");

      # Test whether passive FTP works.
      $server->waitForUnit("vsftpd");
      $server->succeed("echo Hello World > /home/ftp/foo.txt");
      $client->succeed("curl -v ftp://server/foo.txt >&2");

      # Test whether active FTP works.
      $client->succeed("curl -v -P - ftp://server/foo.txt >&2");

      # Test ICMP.
      $client->succeed("ping -c 1 router >&2");
      $router->succeed("ping -c 1 client >&2");

      # If we turn off NAT, the client shouldn't be able to reach the server.
      $router->stopJob("nat");
      $client->fail("curl --fail --connect-timeout 5 http://server/ >&2");
      $client->fail("ping -c 1 server >&2");

      # And make sure that restarting the NAT job works.
      $router->succeed("systemctl start nat");
      $client->succeed("curl --fail http://server/ >&2");
      $client->succeed("ping -c 1 server >&2");
    '';

}
