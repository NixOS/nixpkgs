{ lib, ... }:
{
  name = "odhcpd-ra";
  meta.maintainers = with lib.maintainers; [ savyajha ];

  nodes = {
    router =
      { pkgs, ... }:
      {
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
        environment.systemPackages = [ pkgs.jq ];
        networking.defaultGateway6 = {
          address = "fe80::1";
          interface = "eth0";
        };

        services.odhcpd = {
          enable = true;
          settings = {
            odhcpd.odhcpd.loglevel = 7;
            dhcp.lan = {
              ifname = "eth1";
              ra = "server";
              dhcpv4 = "disabled";
              dhcpv6 = "disabled";
              ra_maxinterval = 10;
              ra_mininterval = 4;
              ra_flags = [ "none" ];
              dns = [ "fd00::53" ];
            };
          };
        };
      };

    kernelclient =
      { pkgs, ... }:
      {
        boot.kernel.sysctl."net.ipv6.conf.all.autoconf" = true;
        environment.systemPackages = with pkgs; [
          jq
          ndisc6
        ];
      };

    networkdclient =
      { pkgs, ... }:
      {
        networking.useDHCP = false;
        networking.useNetworkd = true;
        systemd.network.networks."40-eth1" = {
          matchConfig.Name = "eth1";
          networkConfig.IPv6AcceptRA = true;
        };
        environment.systemPackages = [ pkgs.jq ];
      };
  };

  testScript = ''
    clients = [kernelclient, networkdclient]

    def prefix_query(prefix, cond):
        return (
            "ip -j -6 addr show dev eth1 scope global | jq -e '"
            f"[.[].addr_info[] | select((.local // \"\") | startswith(\"{prefix}\"))] as $a"
            f" | ($a | length) > 0 and ($a | {cond})'"
        )

    def wait_preferred(prefix):
        for c in clients:
            c.wait_until_succeeds(prefix_query(prefix, "any(.preferred_life_time > 0)"), timeout=120)

    def wait_deprecated(prefix):
        for c in clients:
            c.wait_until_succeeds(prefix_query(prefix, "all(.preferred_life_time == 0)"), timeout=120)

    def wait_default_route():
        for c in clients:
            c.wait_until_succeeds("ip -6 route show default dev eth1 | grep -q 'via fe80::'", timeout=120)

    def solicit_ra():
        out = kernelclient.succeed("rdisc6 -1 -r 3 eth1")
        ra = {"prefixes": []}
        prefix = None
        for line in out.splitlines():
            key, _, value = (part.strip() for part in line.partition(":"))
            number = value.split()[0] if value else ""
            if key == "Hop limit":
                ra["hop_limit"] = int(number)
            elif key == "Router lifetime":
                ra["router_lifetime"] = int(number)
            elif key == "Prefix":
                prefix = {"prefix": value, "length": int(value.split("/")[1])}
                ra["prefixes"].append(prefix)
            elif prefix is not None and key == "On-link":
                prefix["on_link"] = value == "Yes"
            elif prefix is not None and key == "Autonomous address conf.":
                prefix["autonomous"] = value == "Yes"
            elif prefix is not None and key == "Valid time":
                prefix["valid"] = int(number)
            elif prefix is not None and key == "Pref. time":
                prefix["preferred"] = int(number)
        print(ra)
        return ra

    def assert_pio(prefix, stale):
        pios = [p for p in solicit_ra()["prefixes"] if p["prefix"] == prefix]
        assert len(pios) == 1, pios
        assert ((pios[0]["valid"], pios[0]["preferred"]) == (0, 0)) == stale, pios

    def set_prefix(old, new):
        if old:
            router.succeed(f"ip -6 addr del {old}1/64 dev eth1")
        if new:
            router.succeed(f"ip -6 addr add {new}1/64 dev eth1 valid_lft 86400 preferred_lft 86400")

    start_all()
    router.wait_for_unit("odhcpd.service")
    for c in clients:
        c.wait_for_unit("network.target")

    with subtest("Prefix appears on the LAN"):
        set_prefix(None, "2001:db8:10::")
        wait_preferred("2001:db8:10:")
        wait_default_route()

    with subtest("A solicited RA carries an on-link, autonomous /64 with sane lifetimes"):
        ra = solicit_ra()
        assert ra["hop_limit"] > 0, ra
        assert ra["router_lifetime"] > 0, ra
        assert any(p["on_link"] and p["autonomous"] for p in ra["prefixes"]), ra
        for p in ra["prefixes"]:
            assert p["length"] == 64 or not p["autonomous"], p
            assert p["preferred"] <= p["valid"], p

    with subtest("Runtime renumbering deprecates the old prefix"):
        set_prefix("2001:db8:10::", "2001:db8:20::")
        wait_preferred("2001:db8:20:")
        wait_deprecated("2001:db8:10:")
        wait_default_route()
        router.succeed("journalctl -u odhcpd | grep -q 'rfc9096: eth1: stale 2001:db8:10::1/64'")
        assert_pio("2001:db8:10::/64", stale=True)

    with subtest("Restart without renumbering keeps the current prefix usable"):
        router.succeed("systemctl restart odhcpd")
        router.wait_for_unit("odhcpd.service")
        for c in clients:
            c.succeed(prefix_query("2001:db8:20:", "any(.preferred_life_time > 0)"))
            c.succeed("ip -6 route show default dev eth1 | grep -q 'via fe80::'")
        assert_pio("2001:db8:20::/64", stale=False)
        assert_pio("2001:db8:10::/64", stale=True)

    with subtest("A default route without a nexthop counts as a default route"):
        router.succeed("ip link add wan0 type dummy && ip link set wan0 up")
        router.succeed("while ip -6 route del default; do :; done")
        router.succeed("ip -6 route add default dev wan0 metric 4096")
        since = router.succeed("date +%s").strip()
        router.succeed("systemctl restart odhcpd")
        router.wait_for_unit("odhcpd.service")
        lifetimes = []
        for _ in range(3):
            lifetimes.append(solicit_ra()["router_lifetime"])
            router.sleep(5)
        assert all(t > 0 for t in lifetimes), lifetimes
        router.fail(f"journalctl -u odhcpd --since @{since} | grep 'No default route'")
        router.succeed("ip link del wan0")
        router.succeed("ip -6 route replace default via fe80::1 dev eth0")

    with subtest("Renumbering while odhcpd is stopped is caught from the state file"):
        router.succeed("systemctl stop odhcpd")
        set_prefix("2001:db8:20::", "2001:db8:30::")
        router.succeed("systemctl start odhcpd")
        wait_preferred("2001:db8:30:")
        wait_deprecated("2001:db8:20:")
        wait_default_route()
        assert_pio("2001:db8:20::/64", stale=True)
        router.succeed("jq -e '.slaac | map(.prefix) | index(\"2001:db8:30::1\")' /var/lib/odhcpd/*")

    with subtest("Router reboot with a clock that went backwards"):
        router.succeed("date -s '+1 day'")
        router.succeed("systemctl stop odhcpd")
        router.shutdown()
        router.start()
        router.wait_for_unit("odhcpd.service")
        set_prefix(None, "2001:db8:40::")
        wait_preferred("2001:db8:40:")
        wait_deprecated("2001:db8:30:")
        wait_default_route()
        assert_pio("2001:db8:40::/64", stale=False)
        assert_pio("2001:db8:30::/64", stale=True)
        assert_pio("2001:db8:20::/64", stale=True)
  '';
}
