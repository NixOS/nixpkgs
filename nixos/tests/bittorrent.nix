# This test runs a Bittorrent tracker on one machine, and verifies
# that two client machines can download the torrent using
# `transmission'.  The first client (behind a NAT router) downloads
# from the initial seeder running on the tracker.  Then we kill the
# initial seeder.  The second client downloads from the first client,
# which only works if the first client successfully uses the UPnP-IGD
# protocol to poke a hole in the NAT.

import ./make-test.nix ({ pkgs, ... }:

let

  # Some random file to serve.
  file = pkgs.nixUnstable.src;

  miniupnpdConf = nodes: pkgs.writeText "miniupnpd.conf"
    ''
      ext_ifname=eth1
      listening_ip=${nodes.router.config.networking.interfaces.eth2.ipAddress}/24
      allow 1024-65535 192.168.2.0/24 1024-65535
    '';

in

{
  name = "bittorrent";

  nodes =
    { tracker =
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission pkgs.bittorrent ];

          # We need Apache on the tracker to serve the torrents.
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          services.httpd.documentRoot = "/tmp";

          networking.firewall.enable = false; # FIXME: figure out what ports we actually need
        };

      router =
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.miniupnpd ];
          virtualisation.vlans = [ 1 2 ];
          networking.nat.enable = true;
          networking.nat.internalInterfaces = [ "eth2" ];
          networking.nat.externalInterface = "eth1";
          networking.firewall.enable = false;
        };

      client1 =
        { config, pkgs, nodes, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
          virtualisation.vlans = [ 2 ];
          networking.defaultGateway =
            nodes.router.config.networking.interfaces.eth2.ipAddress;
          networking.firewall.enable = false;
        };

      client2 =
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
          networking.firewall.enable = false;
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      # Enable NAT on the router and start miniupnpd.
      $router->waitForUnit("nat");
      $router->succeed(
          "iptables -w -t nat -N MINIUPNPD",
          "iptables -w -t nat -A PREROUTING -i eth1 -j MINIUPNPD",
          "echo 1 > /proc/sys/net/ipv4/ip_forward",
          "miniupnpd -f ${miniupnpdConf nodes}"
      );

      # Create the torrent.
      $tracker->succeed("mkdir /tmp/data");
      $tracker->succeed("cp ${file} /tmp/data/test.tar.bz2");
      $tracker->succeed("transmission-create /tmp/data/test.tar.bz2 -t http://${nodes.tracker.config.networking.interfaces.eth1.ipAddress}:6969/announce -o /tmp/test.torrent");
      $tracker->succeed("chmod 644 /tmp/test.torrent");

      # Start the tracker.  !!! use a less crappy tracker
      $tracker->waitForUnit("network.target");
      $tracker->succeed("bittorrent-tracker --port 6969 --dfile /tmp/dstate >&2 &");
      $tracker->waitForOpenPort(6969);

      # Start the initial seeder.
      my $pid = $tracker->succeed("transmission-cli /tmp/test.torrent -M -w /tmp/data >&2 & echo \$!");

      # Now we should be able to download from the client behind the NAT.
      $tracker->waitForUnit("httpd");
      $client1->waitForUnit("network.target");
      $client1->succeed("transmission-cli http://tracker/test.torrent -w /tmp >&2 &");
      $client1->waitForFile("/tmp/test.tar.bz2");
      $client1->succeed("cmp /tmp/test.tar.bz2 ${file}");

      # Bring down the initial seeder.
      $tracker->succeed("kill -9 $pid");

      # Now download from the second client.  This can only succeed if
      # the first client created a NAT hole in the router.
      $client2->waitForUnit("network.target");
      $client2->succeed("transmission-cli http://tracker/test.torrent -M -w /tmp >&2 &");
      $client2->waitForFile("/tmp/test.tar.bz2");
      $client2->succeed("cmp /tmp/test.tar.bz2 ${file}");
    '';

})
