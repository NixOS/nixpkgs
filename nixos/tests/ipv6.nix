# Test of IPv6 functionality in NixOS, including whether router
# solicication/advertisement using radvd works.

import ./make-test.nix ({ pkgs, lib, ...} : {
  name = "ipv6";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  nodes =
    # Remove the interface configuration provided by makeTest so that the
    # interfaces are all configured implicitly
    { client = { ... }: { networking.interfaces = lib.mkForce {}; };

      server =
        { ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.allowedTCPPorts = [ 80 ];
        };

      router =
        { ... }:
        { services.radvd.enable = true;
          services.radvd.config =
            ''
              interface eth1 {
                AdvSendAdvert on;
                # ULA prefix (RFC 4193).
                prefix fd60:cc69:b537:1::/64 { };
              };
            '';
        };
    };

  testScript =
    ''
      # Start the router first so that it respond to router solicitations.
      $router->waitForUnit("radvd");

      startAll;

      $client->waitForUnit("network.target");
      $server->waitForUnit("network.target");
      $server->waitForUnit("httpd.service");

      # Wait until the given interface has a non-tentative address of
      # the desired scope (i.e. has completed Duplicate Address
      # Detection).
      sub waitForAddress {
          my ($machine, $iface, $scope) = @_;
          $machine->waitUntilSucceeds("[ `ip -o -6 addr show dev $iface scope $scope | grep -v tentative | wc -l` -ge 1 ]");
          my $ip = (split /[ \/]+/, $machine->succeed("ip -o -6 addr show dev $iface scope $scope"))[3];
          $machine->log("$scope address on $iface is $ip");
          return $ip;
      }

      subtest "loopback address", sub {
          $client->succeed("ping -c 1 ::1 >&2");
          $client->fail("ping -c 1 ::2 >&2");
      };

      subtest "local link addressing", sub {
          my $clientIp = waitForAddress $client, "eth1", "link";
          my $serverIp = waitForAddress $server, "eth1", "link";
          $client->succeed("ping -c 1 $clientIp%eth1 >&2");
          $client->succeed("ping -c 1 $serverIp%eth1 >&2");
      };

      subtest "global addressing", sub {
          my $clientIp = waitForAddress $client, "eth1", "global";
          my $serverIp = waitForAddress $server, "eth1", "global";
          $client->succeed("ping -c 1 $clientIp >&2");
          $client->succeed("ping -c 1 $serverIp >&2");
          $client->succeed("curl --fail -g http://[$serverIp]");
          $client->fail("curl --fail -g http://[$clientIp]");
      };
      subtest "privacy extensions", sub {
          my $ip = waitForAddress $client, "eth1", "global temporary";
          # Default route should have "src <temporary address>" in it
          $client->succeed("ip r g ::2 | grep $ip");
      };

      # TODO: test reachability of a machine on another network.
    '';
})
