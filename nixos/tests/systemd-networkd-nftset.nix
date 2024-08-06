# This tests systemd-networkd NFTSet option. The interface's statically
# configured address is added to an nft set, and the DHCP configured address is
# added to another. The sets are used by one rule that blocks connections to
# the static address, and one rule that blocks connections to the DHCP address.
# It is tested that the expected connections succeed or fail from another host.
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "systemd-networkd-nftset";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mvnetbiz ];
    };
    nodes = {
      router =
        { ... }:
        {
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
                  DHCPServer = true;
                  IPv6AcceptRA = "no";
                  Address = "10.0.0.1/24";
                };
                dhcpServerConfig = {
                  PoolOffset = 100;
                  PoolSize = 1;
                };
              };
            };
          };
        };

      client =
        { ... }:
        {
          virtualisation.vlans = [ 1 ];
          systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
            nftables = {
              enable = true;
              flushRuleset = true;
              ruleset = ''
                table inet mytable {
                  set dhcp_set {
                    type ipv4_addr
                  }
                  set static_set {
                    type ipv4_addr
                  }
                  chain input {
                    type filter hook input priority filter; policy accept;
                    ip daddr @dhcp_set tcp dport 80 reject with tcp reset
                    ip daddr @static_set tcp dport 8080 reject with tcp reset
                  }
                }
              '';
            };
          };
          systemd.network.networks."01-eth" = {
            name = "eth1";
            networkConfig = {
              DHCP = "ipv4";
              IPv6AcceptRA = "no";
            };
            addresses = [
              {
                Address = "10.0.0.2/24";
                NFTSet = "address:inet:mytable:static_set";
              }
            ];
            dhcpV4Config = {
              NFTSet = "address:inet:mytable:dhcp_set";
            };
          };
          services.nginx = {
            enable = true;
            virtualHosts.localhost.listen = [
              {
                addr = "0.0.0.0";
                port = 80;
              }
              {
                addr = "0.0.0.0";
                port = 8080;
              }
            ];
          };
        };
    };
    testScript =
      { ... }:
      ''
        start_all()

        router.systemctl("start network-online.target")
        client.systemctl("start network-online.target")
        router.wait_for_unit("systemd-networkd-wait-online.service")
        client.wait_for_unit("systemd-networkd-wait-online.service")

        # should be able to ping both IPs
        router.wait_until_succeeds("ping -c 5 10.0.0.2")
        router.wait_until_succeeds("ping -c 5 10.0.0.100")

        client.wait_for_unit("nginx.service")
        client.wait_for_unit("nftables.service")
        # should be able to get static IP, but not the DHCP IP on port 80
        router.wait_until_succeeds("curl 10.0.0.2")
        router.wait_until_fails("curl 10.0.0.100");

        # vice versa on port 8080
        router.wait_until_succeeds("curl 10.0.0.100:8080")
        router.wait_until_fails("curl 10.0.0.2:8080");
      '';
  }
)
