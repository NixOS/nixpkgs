# This test runs FRR and checks if IS-IS routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#

import ../make-test-python.nix ({ pkgs, ... }:
let

  ifAddr = node: iface: (pkgs.lib.head node.networking.interfaces.${iface}.ipv4.addresses).address;

  isisConf1 = ''
    interface eth1
      ip router isis SR
      ipv6 router isis SR
    !
    interface eth2
      ip router isis SR
      ipv6 router isis SR
    !
    router isis SR
      net 49.0001.1111.1111.1111.00
  '';

  isisConf2 = ''
    interface eth1
      ip router isis SR
      ipv6 router isis SR
    !
    interface eth2
      ip router isis SR
      ipv6 router isis SR
    !
    router isis SR
      net 49.0001.2222.2222.2222.00
  '';

in
{
  name = "frr-isis";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ thillux ];
  };

  nodes = {

    client =
      { nodes, ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking.defaultGateway = ifAddr nodes.router1 "eth1";
      };

    router1 =
      { ... }:
      {
        virtualisation.vlans = [ 1 2 ];
        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";
        networking.firewall.enable = false;
        services.frr.isis = {
          enable = true;
          config = isisConf1;
        };

        specialisation.isis.configuration = {
          services.frr.isis.config = isisConf2;
        };

        environment.systemPackages = [
            pkgs.tcpdump
        ];
      };

    router2 =
      { ... }:
      {
        virtualisation.vlans = [ 3 2 ];
        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";
        networking.firewall.enable = false;
        services.frr.isis = {
          enable = true;
          config = isisConf2;
        };
        environment.systemPackages = [
            pkgs.tcpdump
        ];
      };

    server =
      { nodes, ... }:
      {
        virtualisation.vlans = [ 3 ];
        networking.defaultGateway = ifAddr nodes.router2 "eth1";
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # Wait for the networking to start on all machines
      for machine in client, router1, router2, server:
          machine.wait_for_unit("network.target")

      with subtest("Wait for Zebra and isisD"):
          for gw in router1, router2:
              gw.wait_for_unit("zebra")
              gw.wait_for_unit("isisd")

      with subtest("Wait for isis to form adjacencies"):
          for gw in router1, router2:
              gw.wait_until_succeeds("vtysh -c 'show ip route' | grep '^I>'")

      with subtest("Test ICMP"):
          client.wait_until_succeeds("ping -c 3 server >&2")
    '';
})
