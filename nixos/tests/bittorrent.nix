# This test runs a Bittorrent tracker on one machine, and verifies
# that two client machines can download the torrent using
# `transmission'.  The first client (behind a NAT router) downloads
# from the initial seeder running on the tracker.  Then we kill the
# initial seeder.  The second client downloads from the first client,
# which only works if the first client successfully uses the UPnP-IGD
# protocol to poke a hole in the NAT.

{ lib, hostPkgs, ... }:

let

  # Some random file to serve.
  file = hostPkgs.hello.src;

  internalRouterAddress = "192.168.3.1";
  internalClient1Address = "192.168.3.2";
  externalRouterAddress = "80.100.100.1";
  externalClient2Address = "80.100.100.2";
  externalTrackerAddress = "80.100.100.3";

  download-dir = "/var/lib/transmission/Downloads";
  transmissionConfig =
    { pkgs, ... }:
    {
      services.transmission = {
        enable = true;
        settings = {
          dht-enabled = false;
          message-level = 2;
          inherit download-dir;
        };
      };
    };
in

{
  name = "bittorrent";
  meta = with lib.maintainers; {
    maintainers = [
      rob
      bobvanderlinden
    ];
  };

  nodes = {
    tracker =
      { pkgs, ... }:
      {
        imports = [ transmissionConfig ];

        virtualisation.vlans = [ 1 ];
        networking.firewall.enable = false;
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = externalTrackerAddress;
            prefixLength = 24;
          }
        ];

        # We need Apache on the tracker to serve the torrents.
        services.httpd = {
          enable = true;
          virtualHosts = {
            "torrentserver.org" = {
              adminAddr = "foo@example.org";
              documentRoot = "/tmp";
            };
          };
        };
        services.opentracker.enable = true;
      };

    router =
      { pkgs, nodes, ... }:
      {
        virtualisation.vlans = [
          1
          2
        ];
        networking.nat.enable = true;
        networking.nat.internalInterfaces = [ "eth2" ];
        networking.nat.externalInterface = "eth1";
        networking.firewall.enable = true;
        networking.firewall.trustedInterfaces = [ "eth2" ];
        networking.interfaces.eth0.ipv4.addresses = [ ];
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = externalRouterAddress;
            prefixLength = 24;
          }
        ];
        networking.interfaces.eth2.ipv4.addresses = [
          {
            address = internalRouterAddress;
            prefixLength = 24;
          }
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
      {
        imports = [ transmissionConfig ];
        environment.systemPackages = [ pkgs.miniupnpc ];

        virtualisation.vlans = [ 2 ];
        networking.interfaces.eth0.ipv4.addresses = [ ];
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = internalClient1Address;
            prefixLength = 24;
          }
        ];
        networking.defaultGateway = internalRouterAddress;
        networking.firewall.enable = false;
      };

    client2 =
      { pkgs, ... }:
      {
        imports = [ transmissionConfig ];

        virtualisation.vlans = [ 1 ];
        networking.interfaces.eth0.ipv4.addresses = [ ];
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = externalClient2Address;
            prefixLength = 24;
          }
        ];
        networking.firewall.enable = false;
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # Wait for network and miniupnpd.
      router.systemctl("start network-online.target")
      router.wait_for_unit("network-online.target")
      router.wait_for_unit("miniupnpd")

      # Create the torrent.
      tracker.succeed("mkdir ${download-dir}/data")
      tracker.succeed(
          "cp ${file} ${download-dir}/data/test.tar.bz2"
      )
      tracker.succeed(
          "transmission-create ${download-dir}/data/test.tar.bz2 --private --tracker http://${externalTrackerAddress}:6969/announce --outfile /tmp/test.torrent"
      )
      tracker.succeed("chmod 644 /tmp/test.torrent")

      # Start the tracker.  !!! use a less crappy tracker
      tracker.systemctl("start network-online.target")
      tracker.wait_for_unit("network-online.target")
      tracker.wait_for_unit("opentracker.service")
      tracker.wait_for_open_port(6969)

      # Start the initial seeder.
      tracker.succeed(
          "transmission-remote --add /tmp/test.torrent --no-portmap --no-dht --download-dir ${download-dir}/data"
      )

      # Now we should be able to download from the client behind the NAT.
      tracker.wait_for_unit("httpd")
      client1.systemctl("start network-online.target")
      client1.wait_for_unit("network-online.target")
      client1.succeed("transmission-remote --add http://${externalTrackerAddress}/test.torrent >&2 &")
      client1.wait_for_file("${download-dir}/test.tar.bz2")
      client1.succeed(
          "cmp ${download-dir}/test.tar.bz2 ${file}"
      )

      # Bring down the initial seeder.
      tracker.stop_job("transmission")

      # Now download from the second client.  This can only succeed if
      # the first client created a NAT hole in the router.
      client2.systemctl("start network-online.target")
      client2.wait_for_unit("network-online.target")
      client2.succeed(
          "transmission-remote --add http://${externalTrackerAddress}/test.torrent --no-portmap --no-dht >&2 &"
      )
      client2.wait_for_file("${download-dir}/test.tar.bz2")
      client2.succeed(
          "cmp ${download-dir}/test.tar.bz2 ${file}"
      )
    '';
}
