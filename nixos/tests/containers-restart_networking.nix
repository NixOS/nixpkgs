{ pkgs, lib, ... }:
{
  name = "containers-restart_networking";
  meta = {
    maintainers = with lib.maintainers; [ kampfschlaefer ];
  };

  nodes = {
    client = {
      virtualisation.vlans = [ 1 ];

      networking.firewall.enable = false;

      containers.webserver = {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        config = {
          networking.firewall.enable = false;
          networking.interfaces.eth0.ipv4.addresses = [
            {
              address = "192.168.1.122";
              prefixLength = 24;
            }
          ];
        };
      };

      networking.bridges.br0 = {
        interfaces = [ ];
        rstp = false;
      };

      networking.interfaces.br0.ipv4.addresses = [
        {
          address = "192.168.1.1";
          prefixLength = 24;
        }
      ];

      networking.interfaces.eth1 = {
        ipv4.addresses = lib.mkForce [ ];
        ipv6.addresses = lib.mkForce [ ];
      };

      specialisation.eth1.configuration = {
        networking.bridges.br0.interfaces = [ "eth1" ];
        networking.interfaces = {
          eth1.ipv4.addresses = lib.mkForce [ ];
          eth1.ipv6.addresses = lib.mkForce [ ];
          br0.ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
      };

      specialisation.eth1-rstp.configuration = {
        networking.bridges.br0 = {
          interfaces = [ "eth1" ];
          rstp = lib.mkForce true;
        };

        networking.interfaces = {
          eth1.ipv4.addresses = lib.mkForce [ ];
          eth1.ipv6.addresses = lib.mkForce [ ];
          br0.ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
        };
      };
    };
  };

  testScript = ''
    client.start()

    client.wait_for_unit("default.target")

    with subtest("Initial configuration connectivity check"):
        client.succeed("ping 192.168.1.122 -c 1 -n >&2")
        client.succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2")

        client.fail("ip l show eth1 |grep 'master br0' >&2")
        client.fail("grep eth1 /run/br0.interfaces >&2")

    with subtest("Bridged configuration without STP preserves connectivity"):
        client.succeed(
            "/run/booted-system/specialisation/eth1/bin/switch-to-configuration test >&2"
        )

        client.succeed(
            "ping 192.168.1.122 -c 1 -n >&2",
            "nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2",
            "ip l show eth1 |grep 'master br0' >&2",
            "grep eth1 /run/br0.interfaces >&2",
        )

    #  activating rstp needs another service, therefore the bridge will restart and the container will lose its connectivity
    # with subtest("Bridged configuration with STP"):
    #     client.succeed("/run/booted-system/specialisation/eth1-rstp/bin/switch-to-configuration test >&2")
    #     client.execute("ip -4 a >&2")
    #     client.execute("ip l >&2")
    #
    #     client.succeed(
    #         "ping 192.168.1.122 -c 1 -n >&2",
    #         "nixos-container run webserver -- ping -c 1 -n 192.168.1.2 >&2",
    #         "ip l show eth1 |grep 'master br0' >&2",
    #         "grep eth1 /run/br0.interfaces >&2",
    #     )

    with subtest("Reverting to initial configuration preserves connectivity"):
        client.succeed(
            "/run/booted-system/bin/switch-to-configuration test >&2"
        )

        client.succeed("ping 192.168.1.122 -c 1 -n >&2")
        client.succeed("nixos-container run webserver -- ping -c 1 -n 192.168.1.1 >&2")

        client.fail("ip l show eth1 |grep 'master br0' >&2")
        client.fail("grep eth1 /run/br0.interfaces >&2")
  '';

}
