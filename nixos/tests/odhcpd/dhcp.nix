{ lib, ... }:
let
  client =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ndisc6 ];
      networking.useDHCP = false;
      networking.useNetworkd = true;
      networking.interfaces.eth1 = {
        ipv4.addresses = lib.mkForce [ ];
        ipv6.addresses = lib.mkForce [ ];
      };
      systemd.network.networks."30-eth1" = {
        matchConfig.Name = "eth1";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        dhcpV4Config.UseDomains = true;
      };
    };
in
{
  name = "odhcpd-dhcp";
  meta.maintainers = with lib.maintainers; [ savyajha ];

  nodes = {
    router = {
      networking.nftables.enable = true;
      networking.interfaces.eth1.ipv6.addresses = [
        {
          address = "2001:db8:200::1";
          prefixLength = 64;
        }
        {
          address = "2001:db8:300::1";
          prefixLength = 56;
        }
      ];
      networking.defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };

      services.odhcpd = {
        enable = true;
        openFirewall = true;
        settings = {
          odhcpd.odhcpd = {
            maindhcp = true;
            leasefile = "/var/lib/odhcpd/leases";
            hostsdir = "/var/lib/odhcpd";
            loglevel = 7;
            # A path literal, to check it is copied to the store.
            leasetrigger = ./lease-trigger.sh;
          };
          dhcp.lan = {
            ifname = "eth1";
            ra = "server";
            dhcpv4 = "server";
            dhcpv6 = "server";
            ra_flags = [
              "managed-config"
              "other-config"
            ];
            start = 100;
            limit = 50;
            leasetime = "1h";
            dns = [
              "192.168.1.53"
              "2001:db8:200::53"
            ];
            domain = [ "odhcpd.test" ];
          };
          host.reserved = {
            mac = "52:54:00:12:01:01";
            ip = "192.168.1.42";
            name = "reserved";
          };
        };
      };
    };

    dhcpclient = client;

    pdclient = {
      imports = [ client ];
      systemd.network.networks."30-eth1".dhcpV6Config.PrefixDelegationHint = "::/62";
      systemd.network.netdevs."50-downstream".netdevConfig = {
        Name = "downstream";
        Kind = "dummy";
      };
      systemd.network.networks."50-downstream" = {
        matchConfig.Name = "downstream";
        networkConfig.DHCPPrefixDelegation = true;
        dhcpPrefixDelegationConfig.UplinkInterface = "eth1";
      };
    };
  };

  testScript = ''
    import ipaddress
    import re

    clients = [dhcpclient, pdclient]

    def ipv4_address(machine):
        out = machine.succeed("ip -4 -o addr show dev eth1 scope global")
        addrs = [line.split()[3].split("/")[0] for line in out.splitlines()]
        assert len(addrs) == 1, out
        return ipaddress.IPv4Address(addrs[0])

    start_all()
    router.wait_for_unit("odhcpd.service")
    for c in clients:
        c.wait_for_unit("systemd-networkd.service")

    with subtest("DHCPv4 hands out a reserved lease by MAC address"):
        dhcpclient.wait_until_succeeds("ip -4 addr show dev eth1 | grep -q 'inet 192.168.1.42/24'", timeout=120)

    with subtest("DHCPv4 hands out a pool lease"):
        pdclient.wait_until_succeeds("ip -4 -o addr show dev eth1 scope global | grep -q inet", timeout=120)
        address = ipv4_address(pdclient)
        assert ipaddress.IPv4Address("192.168.1.100") <= address <= ipaddress.IPv4Address("192.168.1.149"), address

    with subtest("DHCPv4 options carry the router, DNS and search domain"):
        for c in clients:
            c.wait_until_succeeds("ip -4 route show default | grep -q 'via 192.168.1.3'", timeout=120)
            c.wait_until_succeeds("networkctl status eth1 | grep -q 192.168.1.53", timeout=120)
            c.wait_until_succeeds("networkctl status eth1 | grep -q odhcpd.test", timeout=120)

    with subtest("Stateful DHCPv6 hands out an address and DNS"):
        for c in clients:
            c.wait_until_succeeds("ip -6 addr show dev eth1 scope global | grep -q 'inet6 2001:db8:200:[0-9a-f:]*/128'", timeout=120)
            c.wait_until_succeeds("networkctl status eth1 | grep -q 2001:db8:200::53", timeout=120)

    with subtest("Router advertisements carry the managed and other-config flags"):
        for c in clients:
            ra = c.succeed("rdisc6 -1 -r 3 eth1")
            assert re.search(r"Stateful address conf\.\s*:\s*Yes", ra), ra
            assert re.search(r"Stateful other conf\.\s*:\s*Yes", ra), ra
            c.wait_until_succeeds("ip -6 addr show dev eth1 scope global | grep -q 'inet6 2001:db8:200:[0-9a-f:]*/64'", timeout=120)
            c.wait_until_succeeds("ip -6 route show default dev eth1 | grep -q 'via fe80::'", timeout=120)

    with subtest("DHCPv6 delegates a prefix from the router's /56"):
        pdclient.wait_until_succeeds("ip -6 addr show dev downstream scope global | grep -q 'inet6 2001:db8:300:'", timeout=120)
        out = pdclient.succeed("ip -6 -o addr show dev downstream scope global")
        delegated = ipaddress.IPv6Network(out.split()[3], strict=False)
        assert delegated.subnet_of(ipaddress.IPv6Network("2001:db8:300::/56")), delegated

    with subtest("Leases are recorded in the lease file and hosts file"):
        router.wait_until_succeeds("grep -q 192.168.1.42 /var/lib/odhcpd/leases", timeout=120)
        router.wait_until_succeeds("grep -q pdclient /var/lib/odhcpd/leases", timeout=120)
        router.succeed("cat /var/lib/odhcpd/leases >&2")
        router.succeed("cat /var/lib/odhcpd/odhcpd.hosts.lan >&2")
        router.succeed("grep -q '192.168.1.42.*reserved' /var/lib/odhcpd/odhcpd.hosts.lan")

    with subtest("The lease trigger runs from the store"):
        config = router.succeed("systemctl show -p ExecStart odhcpd").split(" -c ")[1].split()[0]
        router.succeed(f"grep -q 'option leasetrigger /nix/store/[^ ]*-lease-trigger.sh' {config}/dhcp")
        router.wait_until_succeeds("test -e /var/lib/odhcpd/lease-trigger-ran", timeout=120)

    with subtest("The firewall is only opened on the served interface"):
        rules = router.succeed("nft list chain inet nixos-fw input-allow")
        assert re.search(r'iifname "eth1" udp dport \{ 67, 547 \} accept', rules), rules
        others = [line for line in rules.splitlines() if "dport" in line and 'iifname "eth1"' not in line]
        assert not any(re.search(r"\b(67|547)\b", line) for line in others), rules
  '';
}
