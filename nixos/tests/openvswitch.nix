{
  name = "openvswitch";

  nodes = {
    node1 = {
      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;

        vswitches.vs0 = {
          interfaces = {
            eth1 = { };
          };
        };

      };

      systemd.network.networks."40-vs0" = {
        name = "vs0";
        networkConfig.Address = "10.0.0.1/24";
      };

    };

    node2 = {
      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;

        vswitches.vs0 = {
          interfaces = {
            eth1 = { };
          };
        };

      };

      systemd.network.networks."40-vs0" = {
        name = "vs0";
        networkConfig.Address = "10.0.0.2/24";
      };
    };
  };

  testScript = # python
    ''
      start_all()
      node1.wait_for_unit("ovsdb.service")
      node1.wait_for_unit("ovs-vswitchd.service")
      node2.wait_for_unit("ovsdb.service")
      node2.wait_for_unit("ovs-vswitchd.service")

      node1.wait_until_succeeds("ping -c1 10.0.0.2", timeout=30)
      node2.wait_until_succeeds("ping -c1 10.0.0.1", timeout=30)

      with subtest("Restarting ovsdb preserves OpenFlow flows"):
          ovs_ofctl = "ovs-ofctl -O OpenFlow13"
          marker_cookie = "0x5eed"

          def check_marker_flow():
              node1.succeed(
                  f"{ovs_ofctl} dump-flows vs0 | grep -q 'cookie={marker_cookie}'"
              )

          node1.succeed(
              f"{ovs_ofctl} add-flow vs0 "
              f"'cookie={marker_cookie},priority=100,ip,nw_src=192.0.2.1,actions=drop'"
          )
          check_marker_flow()

          node1.succeed("systemctl restart ovsdb.service")
          node1.wait_for_unit("ovsdb.service")
          node1.wait_for_unit("ovs-vswitchd.service")
          node1.wait_for_unit("vs0-netdev.service")

          check_marker_flow()
    '';
}
