{ lib, pkgs, ... }:
{
  name = "networking-tor";
  meta.maintainers = with lib.maintainers; [ deade1e ];

  nodes = {
    client =
      { ... }:
      {
        networking.tor = {
          transPort = 8040;
          dnsPort = 8053;
          client.enable = true;
        };
        environment.systemPackages = with pkgs; [ dnsutils ];
      };

    router =
      { ... }:
      {
        networking.tor = {
          transPort = 7040;
          dnsPort = 7053;
          router.enable = true;
        };
      };

    client_and_router =
      { ... }:
      {
        networking.tor = {
          transPort = 10040;
          dnsPort = 10053;
          client.enable = true;
          router.enable = true;
        };
      };
  };

  testScript = ''
    import re

    def getpkts(node, tcp_port, udp_port):
      tcp_re = rf'counter packets (\d+) bytes \d+ dnat ip to 127.0.0.1:{tcp_port}'
      dns_re = rf'counter packets (\d+) bytes \d+ dnat ip to 127.0.0.1:{udp_port}'
      ruleset = node.succeed("nft list ruleset")
      tcp = int(re.search(tcp_re, ruleset).group(1))
      dns = int(re.search(dns_re, ruleset).group(1))
      return tcp, dns

    client.wait_for_unit("tor.service")
    client.succeed("nft list ruleset | grep tor_nat_output")
    client.succeed("nft list ruleset | grep tor_filter_output")
    client.succeed("ss -tlpn | grep -F '127.0.0.1:8040'")
    client.succeed("ss -ulpn | grep -F '127.0.0.1:8053'")

    # This must fail as the dummy intf is not yet available
    client.fail("nc -vz 1.1.1.1 80")

    # Create a dummy interface and set a fake gateway to trick the OS into
    # trying to route packets
    client.succeed("ip link add dummy0 type dummy")
    client.succeed("ip addr add 10.88.99.2/24 dev dummy0")
    client.succeed("ip link set dummy0 up")
    client.succeed("ip route add default via 10.88.99.1 dev dummy0")

    # Verify that there are ZERO TCP and DNS packets being forwarded to Tor
    tcp, dns = getpkts(client, 8040, 8053)
    assert tcp == 0 and dns == 0

    # Send one DNS request somewhere
    client.execute("nslookup www.google.com 8.8.8.8")

    # Ensure there are more than zero DNS packets and exactly zero TCP packets
    # being forwarded to the Tor daemon.
    tcp, dns = getpkts(client, 8040, 8053)
    assert tcp == 0 and dns > 0

    # This should succeed even though there is no internet, as the packet
    # should be routed to the Tor daemon and it should always reply with a
    # SYN-ACK.
    client.succeed("nc -vz 1.1.1.1 80")

    # And then verify that this packet did go exactly through our TCP DNAT rule
    tcp, dns = getpkts(client, 8040, 8053)
    assert tcp > 0 and dns > 0

    router.wait_for_unit("tor.service")
    router.succeed("nft list ruleset | grep tor_nat_prerouting")
    router.succeed("nft list ruleset | grep tor_filter_forward")
    router.succeed("ss -tlpn | grep -F '0.0.0.0:7040'")
    router.succeed("ss -ulpn | grep -F '0.0.0.0:7053'")

    client_and_router.wait_for_unit("tor.service")
    client_and_router.succeed("nft list ruleset | grep tor_nat_output")
    client_and_router.succeed("nft list ruleset | grep tor_filter_output")
    client_and_router.succeed("nft list ruleset | grep tor_nat_prerouting")
    client_and_router.succeed("nft list ruleset | grep tor_filter_forward")
    client_and_router.succeed("ss -tlpn | grep -F '0.0.0.0:10040'")
    client_and_router.succeed("ss -ulpn | grep -F '0.0.0.0:10053'")
  '';
}
