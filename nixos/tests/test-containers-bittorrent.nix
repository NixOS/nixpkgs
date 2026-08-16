# This test runs a Bittorrent tracker on one machine, and verifies
# that two client machines can download the torrent using
# `aria2c'.  The first client (behind a NAT router) downloads
# from the initial seeder running on the tracker.  Then we kill the
# initial seeder.  The second client downloads from the first client,
# which only works if the first client successfully uses the UPnP-IGD
# protocol to poke a hole in the NAT.

# We use aria2 as the initial seeder because transmission
# fails in the sandbox because of systemd hardening settings,
# namely MountAPIVFS=yes, so we get the following error:

# $ journalctl --unit transmission.service
# (n-daemon)[417]: transmission.service: Failed to create destination mount point node '/run/transmission/run/host/.os-release-stage/', ignoring: Read-only file system
# (n-daemon)[417]: transmission.service: Failed to mount /run/systemd/propagate/.os-release-stage to /run/transmission/run/host/.os-release-stage/: No such file or directory
# (n-daemon)[417]: transmission.service: Failed to set up mount namespacing: /run/host/.os-release-stage/: No such file or directory
# (n-daemon)[417]: transmission.service: Failed at step NAMESPACE spawning /nix/store/zfksw9bllp95pl45d1nxmpd2lks42bkj-transmission-4.0.6/bin/transmission-daemon: No such file or directory
# systemd[1]: transmission.service: Main process exited, code=exited, status=226/NAMESPACE

{ lib, hostPkgs, ... }:

let

  # Some random file to serve.
  file = hostPkgs.hello.src;

  internalRouterAddress = "192.168.3.1";
  internalClient1Address = "192.168.3.2";

  # cannot use documentation networks (198.51.100.0/24 or 192.0.2.0/24) here
  # because miniupnpd recognizes them as such and refuses to work with them
  # https://github.com/miniupnp/miniupnp/blob/2a74cb2f27cacf06d2b50c187e8f90aa1f5c2528/miniupnpd/miniupnpd.c#L998
  externalRouterAddress = "80.100.100.1";
  externalClient2Address = "80.100.100.2";
  externalTrackerAddress = "80.100.100.3";

  download-dir = "/tmp/aria2-downloads";
  peerConfig =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.aria2
        pkgs.transmission_4 # only needed for transmission-create
      ];
    };
in

{
  name = "bittorrent";
  meta = {
    maintainers = [
      lib.maintainers.kmein
    ];
  };

  containers = {
    tracker =
      { pkgs, ... }:
      {
        imports = [ peerConfig ];

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
      { pkgs, containers, ... }:
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
        networking.nftables.enable = true;
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
      { pkgs, containers, ... }:
      {
        imports = [ peerConfig ];
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
        imports = [ peerConfig ];

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
    { containers, ... }:
    ''
      start_all()

      # Wait for network and miniupnpd.
      router.systemctl("start network-online.target")
      router.wait_for_unit("network-online.target")
      router.wait_for_unit("miniupnpd")

      # Create the torrent.
      tracker.succeed("mkdir -p ${download-dir}")
      tracker.succeed(
          "cp ${file} ${download-dir}/test.tar.bz2"
      )
      tracker.succeed(
          "transmission-create ${download-dir}/test.tar.bz2 --private --tracker http://${externalTrackerAddress}:6969/announce --outfile /tmp/test.torrent"
      )
      tracker.succeed("chmod 644 /tmp/test.torrent")

      # Start the tracker
      tracker.systemctl("start network-online.target")
      tracker.wait_for_unit("network-online.target")
      tracker.wait_for_unit("opentracker.service")
      tracker.wait_for_open_port(6969)

      # --- Start the initial seeder using aria2 ---
      # https://stackoverflow.com/a/44528978
      tracker.execute(
          "aria2c --enable-dht=false --seed-time=999 --dir=${download-dir} "
          "-V --seed-ratio=0.0 "
          "/tmp/test.torrent >/dev/null &"
      )

      # --- Wait until the tracker shows we are seeding ---
      tracker.wait_until_succeeds("curl -s http://localhost:6969/stats | grep -q 'serving 1 torrents'")

      # Now we should be able to download from the client behind the NAT.
      tracker.wait_for_unit("httpd")

      def connect_from(machine):
          machine.systemctl("start network-online.target")
          machine.wait_for_unit("network-online.target")
          machine.execute(
              "aria2c --enable-dht=false --seed-time=999 --dir=${download-dir} "
              "http://${externalTrackerAddress}/test.torrent >/dev/null &"
          )
          machine.wait_until_succeeds(
              "cmp ${download-dir}/test.tar.bz2 ${file}"
          ) # Wait for download to finish and verify

      connect_from(client1)

      # --- Bring down the initial seeder ---
      tracker.succeed("pkill aria2c")

      # Now download from the second client.  This can only succeed if
      # the first client created a NAT hole in the router.
      connect_from(client2)
    '';
}
