# This test runs FRR and checks if BGP routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#

import ../make-test-python.nix ({ pkgs, ... }:
let

  ifAddr = node: iface: (pkgs.lib.head node.networking.interfaces.${iface}.ipv4.addresses).address;

  bgpConf1 = neigh: ''
    router bgp 10
      redistribute kernel
      redistribute connected
      neighbor ${neigh} remote-as 20
  '';

  bgpConf2 = neigh: ''
    router bgp 20
      redistribute kernel
      redistribute connected
      neighbor ${neigh} remote-as 10
  '';

in
{
  name = "frr-bgp";

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
      { nodes, ... }:
      {
        virtualisation.vlans = [ 1 2 ];
        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p tcp --dport 179 -j ACCEPT";
        services.frr.bgp = {
          enable = true;
          config = (bgpConf1 (ifAddr nodes.router2 "eth2"));
        };
      };

    router2 =
      { nodes, ... }:
      {
        virtualisation.vlans = [ 3 2 ];
        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p tcp --dport 179 -j ACCEPT";
        services.frr.bgp = {
          enable = true;
          config = (bgpConf2 (ifAddr nodes.router1 "eth2"));
        };
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

      with subtest("Wait for Zebra and BGPD"):
          for gw in router1, router2:
              gw.wait_for_unit("zebra")
              gw.wait_for_unit("bgpd")

      with subtest("Wait for BGP to form adjacencies"):
          for gw in router1, router2:
              gw.wait_until_succeeds("vtysh -c 'show bgp neighbors' | grep 'established 1'")
              gw.wait_until_succeeds("vtysh -c 'show ip route' | grep '^B>'")

      with subtest("Test ICMP"):
          client.wait_until_succeeds("ping -c 3 server >&2")
    '';
})
