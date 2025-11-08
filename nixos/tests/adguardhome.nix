{
  name = "adguardhome";

  nodes = {
    nullConf = {
      services.adguardhome.enable = true;
    };

    emptyConf = {
      services.adguardhome = {
        enable = true;

        settings = { };
      };
    };

    schemaVersionBefore23 = {
      services.adguardhome = {
        enable = true;

        settings.schema_version = 20;
      };
    };

    declarativeConf = {
      services.adguardhome = {
        enable = true;

        mutableSettings = false;
        settings.dns.bootstrap_dns = [ "127.0.0.1" ];
      };
    };

    mixedConf = {
      services.adguardhome = {
        enable = true;

        mutableSettings = true;
        settings.dns.bootstrap_dns = [ "127.0.0.1" ];
      };
    };

    dhcpConf =
      { lib, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          # Configure static IP for DHCP server
          useDHCP = false;
          interfaces."eth1" = lib.mkForce {
            useDHCP = false;
            ipv4 = {
              addresses = [
                {
                  address = "10.0.10.1";
                  prefixLength = 24;
                }
              ];

              routes = [
                {
                  address = "10.0.10.0";
                  prefixLength = 24;
                }
              ];
            };
          };

          # Required for DHCP
          firewall.allowedUDPPorts = [
            67
            68
          ];
        };

        services.adguardhome = {
          enable = true;
          allowDHCP = true;
          mutableSettings = false;
          settings = {
            dns.bootstrap_dns = [ "127.0.0.1" ];
            dhcp = {
              # This implicitly enables CAP_NET_RAW
              enabled = true;
              interface_name = "eth1";
              local_domain_name = "lan";
              dhcpv4 = {
                gateway_ip = "10.0.10.1";
                range_start = "10.0.10.100";
                range_end = "10.0.10.101";
                subnet_mask = "255.255.255.0";
              };
            };
          };
        };
      };

    client =
      { lib, ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking = {
          interfaces.eth1 = {
            useDHCP = true;
            ipv4.addresses = lib.mkForce [ ];
          };
        };
      };
  };

  testScript = ''
    with subtest("Minimal (settings = null) config test"):
      nullConf.wait_for_unit("adguardhome.service")
      nullConf.wait_for_open_port(3000)

    with subtest("Default config test"):
      emptyConf.wait_for_unit("adguardhome.service")
      emptyConf.wait_for_open_port(3000)

    with subtest("Default schema_version 23 config test"):
      schemaVersionBefore23.wait_for_unit("adguardhome.service")
      schemaVersionBefore23.wait_for_open_port(3000)

    with subtest("Declarative config test, DNS will be reachable"):
      declarativeConf.wait_for_unit("adguardhome.service")
      declarativeConf.wait_for_open_port(53)
      declarativeConf.wait_for_open_port(3000)

    with subtest("Mixed config test, check whether merging works"):
      mixedConf.wait_for_unit("adguardhome.service")
      mixedConf.wait_for_open_port(53)
      mixedConf.wait_for_open_port(3000)
      # Test whether merging works properly, even if nothing is changed
      mixedConf.systemctl("restart adguardhome.service")
      mixedConf.wait_for_unit("adguardhome.service")
      mixedConf.wait_for_open_port(3000)

    with subtest("Testing successful DHCP start"):
      dhcpConf.wait_for_unit("adguardhome.service")
      client.systemctl("start network-online.target")
      client.wait_for_unit("network-online.target")
      # Test IP assignment via DHCP
      dhcpConf.wait_until_succeeds("ping -c 5 10.0.10.100")
      # Test hostname resolution over DHCP-provided DNS
      dhcpConf.wait_until_succeeds("ping -c 5 client.lan")
  '';
}
