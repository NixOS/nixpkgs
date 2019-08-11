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
  file = pkgs.hello.src;

  internalRouterAddress = "192.168.3.1";
  internalClient1Address = "192.168.3.2";
  externalRouterAddress = "80.100.100.1";
  externalClient2Address = "80.100.100.2";
  externalTrackerAddress = "80.100.100.3";
in

{
  name = "bittorrent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco rob bobvanderlinden ];
  };

  nodes =
    { tracker =
        { pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];

          virtualisation.vlans = [ 1 ];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalTrackerAddress; prefixLength = 24; }
          ];

          # We need Apache on the tracker to serve the torrents.
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          services.httpd.documentRoot = "/tmp";

          networking.firewall.enable = false;

          services.opentracker.enable = true;

          services.transmission.enable = true;
          services.transmission.settings.dht-enabled = false;
          services.transmission.settings.port-forwaring-enabled = false;
        };

      router =
        { pkgs, nodes, ... }:
        { virtualisation.vlans = [ 1 2 ];
          networking.nat.enable = true;
          networking.nat.internalInterfaces = [ "eth2" ];
          networking.nat.externalInterface = "eth1";
          networking.firewall.enable = true;
          networking.firewall.trustedInterfaces = [ "eth2" ];
          networking.interfaces.eth0.ipv4.addresses = [];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalRouterAddress; prefixLength = 24; }
          ];
          networking.interfaces.eth2.ipv4.addresses = [
            { address = internalRouterAddress; prefixLength = 24; }
          ];
          services.miniupnpd = {
            enable = true;
            externalInterface = "eth1";
            internalIPs = [ "eth2" ];
            appendConfig = ''
              ext_ip=${externalRouterAddress}
            '';
          };
        };

      client1 =
        { pkgs, nodes, ... }:
        { environment.systemPackages = [ pkgs.transmission pkgs.miniupnpc ];
          virtualisation.vlans = [ 2 ];
          networking.interfaces.eth0.ipv4.addresses = [];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = internalClient1Address; prefixLength = 24; }
          ];
          networking.defaultGateway = internalRouterAddress;
          networking.firewall.enable = false;
          services.transmission.enable = true;
          services.transmission.settings.dht-enabled = false;
          services.transmission.settings.message-level = 3;
        };

      client2 =
        { pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
          virtualisation.vlans = [ 1 ];
          networking.interfaces.eth0.ipv4.addresses = [];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalClient2Address; prefixLength = 24; }
          ];
          networking.firewall.enable = false;
          services.transmission.enable = true;
          services.transmission.settings.dht-enabled = false;
          services.transmission.settings.port-forwaring-enabled = false;
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      # Wait for network and miniupnpd.
      $router->waitForUnit("network-online.target");
      $router->waitForUnit("miniupnpd");

      # Create the torrent.
      $tracker->succeed("mkdir /tmp/data");
      $tracker->succeed("cp ${file} /tmp/data/test.tar.bz2");
      $tracker->succeed("transmission-create /tmp/data/test.tar.bz2 --private --tracker http://${externalTrackerAddress}:6969/announce --outfile /tmp/test.torrent");
      $tracker->succeed("chmod 644 /tmp/test.torrent");

      # Start the tracker.  !!! use a less crappy tracker
      $tracker->waitForUnit("network-online.target");
      $tracker->waitForUnit("opentracker.service");
      $tracker->waitForOpenPort(6969);

      # Start the initial seeder.
      $tracker->succeed("transmission-remote --add /tmp/test.torrent --no-portmap --no-dht --download-dir /tmp/data");

      # Now we should be able to download from the client behind the NAT.
      $tracker->waitForUnit("httpd");
      $client1->waitForUnit("network-online.target");
      $client1->succeed("transmission-remote --add http://${externalTrackerAddress}/test.torrent --download-dir /tmp >&2 &");
      $client1->waitForFile("/tmp/test.tar.bz2");
      $client1->succeed("cmp /tmp/test.tar.bz2 ${file}");

      # Bring down the initial seeder.
      # $tracker->stopJob("transmission");

      # Now download from the second client.  This can only succeed if
      # the first client created a NAT hole in the router.
      $client2->waitForUnit("network-online.target");
      $client2->succeed("transmission-remote --add http://${externalTrackerAddress}/test.torrent --no-portmap --no-dht --download-dir /tmp >&2 &");
      $client2->waitForFile("/tmp/test.tar.bz2");
      $client2->succeed("cmp /tmp/test.tar.bz2 ${file}");
    '';

})
