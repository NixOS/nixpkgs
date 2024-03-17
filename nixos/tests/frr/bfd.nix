# This test runs FRR and checks if BFD with OSPF routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#

import ../make-test-python.nix ({ pkgs, ... }:
let

  ifAddr = node: iface: (pkgs.lib.head node.networking.interfaces.${iface}.ipv4.addresses).address;

  bfdConf1 = neigh: ''
    bfd
      peer ${neigh}
        no shutdown
      !
    !
  '';

  bgpConf1 = neigh: ''
    router bgp 10
      redistribute kernel
      redistribute connected
      neighbor ${neigh} remote-as 20
      neighbor ${neigh} bfd
  '';

  bfdConf2 = neigh: ''
    bfd
      peer ${neigh}
        no shutdown
      !
    !
  '';

  bgpConf2 = neigh: ''
    router bgp 20
      redistribute kernel
      redistribute connected
      neighbor ${neigh} remote-as 10
      neighbor ${neigh} bfd
  '';

in
{
  name = "frr-bfd";

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
        networking.firewall.enable = false;
        services.frr.bfd = {
          enable = true;
          config = (bfdConf1 (ifAddr nodes.router2 "eth2"));
        };
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
        networking.firewall.enable = false;
        services.frr.bfd = {
          enable = true;
          config = (bfdConf2 (ifAddr nodes.router1 "eth2"));
        };
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

      with subtest("Wait for Zebra and BFDD"):
          for gw in router1, router2:
              gw.wait_for_unit("zebra")
              gw.wait_for_unit("bfdd")

      with subtest("Wait for bfd to form adjacencies"):
          for gw in router1, router2:
              gw.wait_until_succeeds("vtysh -c 'show bfd peers' | grep 'Status: up'")

      with subtest("Wait for BGPD"):
          for gw in router1, router2:
              gw.wait_for_unit("bgpd")

      with subtest("Wait for BGP to form adjacencies"):
          for gw in router1, router2:
              gw.wait_until_succeeds("vtysh -c 'show bgp neighbors' | grep 'established 1'")
              gw.wait_until_succeeds("vtysh -c 'show ip route' | grep '^B>'")

      # kill bgp and bfd, routes should be gone now
      router2.execute("systemctl stop bgpd")
      router2.execute("systemctl stop bfdd")

      # BGP routes should be gone rather fast
      router1.wait_until_succeeds("vtysh -c 'show ip route' | grep -v '^B>'", timeout=5)

      # start bgp and bfd again routes should apper fast
      router2.execute("systemctl start bfdd")
      router2.execute("systemctl start bgpd")

      router1.wait_until_succeeds("vtysh -c 'show ip route' | grep '^B>'", timeout=5)
    '';
})
