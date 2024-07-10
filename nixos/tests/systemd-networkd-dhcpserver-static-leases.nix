# In contrast to systemd-networkd-dhcpserver, this test configures
# the router with a static DHCP lease for the client's MAC address.
import ./make-test-python.nix ({ lib, ... }: {
  name = "systemd-networkd-dhcpserver-static-leases";
  meta = with lib.maintainers; {
    maintainers = [ veehaitch ];
  };
  nodes = {
    router = {
      virtualisation.vlans = [ 1 ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };
      systemd.network = {
        networks = {
          # systemd-networkd will load the first network unit file
          # that matches, ordered lexiographically by filename.
          # /etc/systemd/network/{40-eth1,99-main}.network already
          # exists. This network unit must be loaded for the test,
          # however, hence why this network is named such.
          "01-eth1" = {
            name = "eth1";
            networkConfig = {
              # IPForward prevents dynamic address configuration
              IPForward = true;
              DHCPServer = true;
              Address = "10.0.0.1/24";
            };
            dhcpServerStaticLeases = [{
              MACAddress = "02:de:ad:be:ef:01";
              Address = "10.0.0.10";
            }];
          };
        };
      };
    };

    client = {
      virtualisation.vlans = [ 1 ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      systemd.network = {
        enable = true;
        links."10-eth1" = {
          matchConfig.OriginalName = "eth1";
          linkConfig.MACAddress = "02:de:ad:be:ef:01";
        };
        networks."40-eth1" = {
          matchConfig.Name = "eth1";
          networkConfig = {
            DHCP = "ipv4";
            IPv6AcceptRA = false;
          };
          # This setting is important to have the router assign the
          # configured lease based on the client's MAC address. Also see:
          # https://github.com/systemd/systemd/issues/21368#issuecomment-982193546
          dhcpV4Config.ClientIdentifier = "mac";
          linkConfig.RequiredForOnline = "routable";
        };
      };
      networking = {
        useDHCP = false;
        firewall.enable = false;
        interfaces.eth1 = lib.mkForce {};
      };
    };
  };
  testScript = ''
    start_all()

    with subtest("check router network configuration"):
      router.wait_for_unit("systemd-networkd-wait-online.service")
      eth1_status = router.succeed("networkctl status eth1")
      assert "Network File: /etc/systemd/network/01-eth1.network" in eth1_status, \
        "The router interface eth1 is not using the expected network file"
      assert "10.0.0.1" in eth1_status, "Did not find expected router IPv4"

    with subtest("check client network configuration"):
      client.wait_for_unit("systemd-networkd-wait-online.service")
      eth1_status = client.succeed("networkctl status eth1")
      assert "Network File: /etc/systemd/network/40-eth1.network" in eth1_status, \
        "The client interface eth1 is not using the expected network file"
      assert "10.0.0.10" in eth1_status, "Did not find expected client IPv4"

    with subtest("router and client can reach each other"):
      client.wait_until_succeeds("ping -c 5 10.0.0.1")
      router.wait_until_succeeds("ping -c 5 10.0.0.10")
  '';
})
