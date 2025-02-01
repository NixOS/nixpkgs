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

      node1.succeed("ping -c3 10.0.0.2")
      node2.succeed("ping -c3 10.0.0.1")
    '';
}
