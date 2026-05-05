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

    clearclient =
      { nodes, ... }:
      {
        environment.systemPackages = with pkgs; [ dnsutils ];
        # Set the router node as the gateway.
        networking.defaultGateway = nodes.router.networking.primaryIPAddress;
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
  };

  testScript = ''
    import re

    # Return packet counters found in Tor's output chain.
    def get_output_pkgs(node, tcp_port, dns_port):
      tcp_re = rf'counter packets (\d+) bytes \d+ dnat ip to 127.0.0.1:{tcp_port}'
      dns_re = rf'counter packets (\d+) bytes \d+ dnat ip to 127.0.0.1:{dns_port}'
      ruleset = node.succeed("nft list chain inet tor tor_nat_output")
      tcp = int(re.search(tcp_re, ruleset).group(1))
      dns = int(re.search(dns_re, ruleset).group(1))
      return tcp, dns

    # Return packet counters found in Tor's prerouting chain.
    def get_prerouting_pkts(node, tcp_port, dns_port):
      tcp_re = rf'ip protocol tcp tcp flags syn counter packets (\d+) bytes \d+ redirect to :{tcp_port}'
      dns_re = rf'ip protocol udp udp dport 53 counter packets (\d+) bytes \d+ redirect to :{dns_port}'
      ruleset = node.succeed("nft list chain inet tor-router tor_nat_prerouting")
      tcp = int(re.search(tcp_re, ruleset).group(1))
      dns = int(re.search(dns_re, ruleset).group(1))
      return tcp, dns

    router.wait_for_unit("tor.service")
    router.succeed("nft list ruleset | grep tor_nat_prerouting")
    router.succeed("nft list ruleset | grep tor_filter_forward")
    router.succeed("ss -tlpn | grep -F '0.0.0.0:7040'")
    router.succeed("ss -ulpn | grep -F '0.0.0.0:7053'")

    tcp, dns = get_prerouting_pkts(router, 7040, 7053)
    assert tcp == 0 and dns == 0

    clearclient.wait_for_unit("multi-user.target")

    # If routed through a Tor gateway, the Tor daemon always replies with a
    # SYN-ACK, no matter its network state.
    clearclient.succeed("nc -vz 1.1.1.1 80")

    # At this point we should have TCP packets but no DNS packets.
    tcp, dns = get_prerouting_pkts(router, 7040, 7053)
    assert tcp > 0 and dns == 0

    # This should fail as without connectivity the Tor daemon cannot to resolve domains.
    clearclient.fail("nslookup -timeout=1 www.google.com 8.8.8.8")
    tcp, dns = get_prerouting_pkts(router, 7040, 7053)
    assert tcp > 0 and dns > 0

    # Trying to resolve a .onion address instead should always succeed as the
    # Tor daemon optimistically replies with a IP within VirtualAddrNetworkIPv4
    # even without connectivity.
    clearclient.succeed("nslookup -timeout=1 duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion 8.8.8.8 | grep -F 'Address: 10.'")

    client.wait_for_unit("tor.service")
    client.succeed("nft list ruleset | grep tor_nat_output")
    client.succeed("nft list ruleset | grep tor_filter_output")
    client.succeed("ss -tlpn | grep -F '127.0.0.1:8040'")
    client.succeed("ss -ulpn | grep -F '127.0.0.1:8053'")

    # This must fail as the dummy intf is not yet available
    client.fail("nc -vz 1.1.1.1 80")

    # Create a dummy interface and set a fake gateway to trick the OS into
    # trying to route packets.
    client.succeed("ip link add dummy0 type dummy")
    client.succeed("ip addr add 10.88.99.2/24 dev dummy0")
    client.succeed("ip link set dummy0 up")
    client.succeed("ip route add default via 10.88.99.1 dev dummy0")

    # Verify that there are ZERO TCP and DNS packets being forwarded to Tor.
    tcp, dns = get_output_pkgs(client, 8040, 8053)
    assert tcp == 0 and dns == 0

    # Send one DNS request somewhere.
    client.fail("nslookup -timeout=1 www.google.com 8.8.8.8")

    # Ensure there are more than zero DNS packets and exactly zero TCP packets
    # being forwarded to the Tor daemon.
    tcp, dns = get_output_pkgs(client, 8040, 8053)
    assert tcp == 0 and dns > 0

    # This should succeed even though there is no internet, as the packet
    # should be routed to the Tor daemon and it should always reply with a
    # SYN-ACK.
    client.succeed("nc -vz 1.1.1.1 80")

    # And then verify that this packet did go exactly through our TCP DNAT rule.
    tcp, dns = get_output_pkgs(client, 8040, 8053)
    assert tcp > 0 and dns > 0

    # Try to resolve a .onion because why not.
    client.succeed("nslookup -timeout=1 duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion 8.8.8.8 | grep -F 'Address: 10.'")
  '';
}
