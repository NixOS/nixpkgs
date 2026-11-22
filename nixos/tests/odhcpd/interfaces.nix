{ lib, ... }:
let
  noAddrs =
    ifs:
    lib.genAttrs ifs (_: {
      ipv4.addresses = lib.mkForce [ ];
      ipv6.addresses = lib.mkForce [ ];
    });

  client =
    vlan:
    { pkgs, ... }:
    {
      virtualisation.vlans = [ vlan ];
      boot.kernel.sysctl."net.ipv6.conf.all.autoconf" = true;
      networking.interfaces = noAddrs [ "eth1" ];
      environment.systemPackages = [ pkgs.jq ];
    };
in
{
  name = "odhcpd-interfaces";
  meta.maintainers = with lib.maintainers; [ savyajha ];

  nodes = {
    # Announces 2001:db8:f::/64 on the router's WAN link.
    upstream = {
      virtualisation.vlans = [ 2 ];
      networking.interfaces = noAddrs [ "eth1" ] // {
        eth1.ipv6.addresses = lib.mkForce [
          {
            address = "2001:db8:f::1";
            prefixLength = 64;
          }
        ];
      };
      services.odhcpd = {
        enable = true;
        settings.dhcp.lan = {
          ifname = "eth1";
          ra = "server";
          ra_maxinterval = 10;
          ra_mininterval = 4;
        };
      };
    };

    # Serves br0 (created by the test), relays RAs from wan0 (created by the test) to br1,
    # and has a section for ppp0 that serves nothing.
    router =
      { pkgs, ... }:
      {
        virtualisation.vlans = [
          1
          2
          3
        ];
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
        networking.interfaces = noAddrs [
          "eth1"
          "eth2"
          "eth3"
        ];
        networking.bridges.br1.interfaces = [ "eth3" ];
        networking.defaultGateway6 = {
          address = "fe80::1";
          interface = "eth0";
        };
        environment.systemPackages = [ pkgs.jq ];

        services.odhcpd = {
          enable = true;
          openFirewall = true;
          settings = {
            odhcpd.odhcpd.loglevel = 7;
            dhcp.lan = {
              ifname = "br0";
              ra = "server";
              dhcpv4 = "disabled";
              dhcpv6 = "disabled";
              ra_maxinterval = 10;
              ra_mininterval = 4;
            };
            dhcp.relayed = {
              ifname = "br1";
              ra = "relay";
              ndp = "relay";
            };
            dhcp.upstream = {
              ifname = "wan0";
              master = true;
              ra = "relay";
              ndp = "relay";
            };
            dhcp.wan = {
              ifname = "ppp0";
              ra = "disabled";
              dhcpv4 = "disabled";
              dhcpv6 = "disabled";
              ndp = "disabled";
            };
          };
        };
      };

    lanclient = client 1;
    relayclient = client 3;
  };

  testScript = ''
    def prefix_query(prefix, cond):
        return (
            "ip -j -6 addr show dev eth1 scope global | jq -e '"
            f"[.[].addr_info[] | select((.local // \"\") | startswith(\"{prefix}\"))] as $a"
            f" | ($a | length) > 0 and ($a | {cond})'"
        )

    def wait_preferred(c, prefix):
        c.wait_until_succeeds(prefix_query(prefix, "any(.preferred_life_time > 0)"), timeout=120)

    def wait_deprecated(c, prefix):
        c.wait_until_succeeds(prefix_query(prefix, "all(.preferred_life_time == 0)"), timeout=120)

    def mainpid():
        return router.succeed("systemctl show -P MainPID odhcpd").strip()

    def cursor():
        return router.succeed("journalctl -n0 --show-cursor | tail -1 | cut -d' ' -f3").strip()

    def wait_reloaded(iface, since):
        router.wait_until_succeeds(
            f"journalctl --after-cursor='{since}' -u odhcpd-reload-{iface} | grep -q Finished"
        )

    def make_br0(prefix):
        router.succeed(
            "ip link add br0 type bridge",
            "ip link set eth1 master br0",
            "ip link set br0 up",
            f"ip -6 addr add {prefix}1/64 dev br0 valid_lft 86400 preferred_lft 86400",
        )

    start_all()
    upstream.wait_for_unit("odhcpd.service")
    router.wait_for_unit("odhcpd.service")
    router.wait_until_succeeds("journalctl -b -u odhcpd-reload-br1 | grep -q Finished")
    for c in (lanclient, relayclient):
        c.wait_for_unit("network.target")
    pid = mainpid()

    with subtest("Only interfaces odhcpd serves get reload units and firewall rules"):
        units = router.succeed(
            "systemctl list-unit-files --plain --no-legend 'odhcpd-reload-*' | cut -d' ' -f1"
        ).split()
        assert sorted(units) == [
            "odhcpd-reload-br0.service",
            "odhcpd-reload-br1.service",
            "odhcpd-reload-wan0.service",
        ], units
        rules = router.succeed("ip6tables-save")
        for iface in ("br0", "br1", "wan0"):
            assert f"-i {iface} " in rules, rules
        assert "ppp0" not in rules, rules

    with subtest("A served interface created after startup is picked up"):
        since = cursor()
        make_br0("2001:db8:a::")
        wait_reloaded("br0", since)
        wait_preferred(lanclient, "2001:db8:a:")
        assert mainpid() == pid

    with subtest("A recreated interface is picked up and its old prefix is deprecated"):
        router.succeed("ip link del br0")
        router.wait_until_fails("ip link show br0")
        since = cursor()
        make_br0("2001:db8:b::")
        wait_reloaded("br0", since)
        wait_preferred(lanclient, "2001:db8:b:")
        wait_deprecated(lanclient, "2001:db8:a:")
        assert mainpid() == pid

    with subtest("A relay master created after startup is picked up"):
        since = cursor()
        router.succeed(
            "ip link add wan0 type bridge",
            "ip link set eth2 master wan0",
            "ip link set wan0 up",
        )
        wait_reloaded("wan0", since)
        wait_preferred(relayclient, "2001:db8:f:")
        assert mainpid() == pid

    with subtest("An interface odhcpd does not serve causes no reload"):
        since = cursor()
        router.succeed("ip link add ppp0 type dummy", "ip link set ppp0 up")
        router.wait_for_unit("sys-subsystem-net-devices-ppp0.device")
        router.sleep(2)
        router.fail(f"journalctl --after-cursor='{since}' | grep -q 'Reloading odhcpd'")
        assert mainpid() == pid
  '';
}
