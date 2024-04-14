# This is a simple distributed test involving a topology with two
# separate virtual networks - the "inside" and the "outside" - with a
# client on the inside network, a server on the outside network, and a
# router connected to both that performs Network Address Translation
# for the client.
import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    routerBase =
      lib.mkMerge [
        { virtualisation.vlans = [ 2 1 ];
          networking.nftables.enable = true;
          networking.nat.internalIPs = [ "192.168.1.0/24" ];
          networking.nat.externalInterface = "eth1";
        }
      ];
  in
  {
    name = "dublin-traceroute";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ baloo ];
    };

    nodes.client = { nodes, ... }: {
      imports = [ ./common/user-account.nix ];
      virtualisation.vlans = [ 1 ];

      networking.defaultGateway =
        (builtins.head nodes.router.networking.interfaces.eth2.ipv4.addresses).address;
      networking.nftables.enable = true;

      programs.dublin-traceroute.enable = true;
    };

    nodes.router = { ... }: {
      virtualisation.vlans = [ 2 1 ];
      networking.nftables.enable = true;
      networking.nat.internalIPs = [ "192.168.1.0/24" ];
      networking.nat.externalInterface = "eth1";
      networking.nat.enable = true;
    };

    nodes.server = { ... }: {
      virtualisation.vlans = [ 2 ];
      networking.firewall.enable = false;
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.vsftpd.enable = true;
      services.vsftpd.anonymousUser = true;
    };

    testScript = ''
      client.start()
      router.start()
      server.start()

      server.wait_for_unit("network.target")
      router.wait_for_unit("network.target")
      client.wait_for_unit("network.target")

      # Make sure we can trace from an unprivileged user
      client.succeed("sudo -u alice dublin-traceroute server")
    '';
  })
