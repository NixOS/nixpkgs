let
  ulaPrefix = "fd5f:e1a2:4f0c::/64";
  hostMAC = "72:ec:00:8b:75:44";
  hostSLAACv6 = "fd5f:e1a2:4f0c:0:70ec:ff:fe8b:7544/64";
  containerMAC = "b2:65:3f:c9:6b:10";
  containerSLAACv6 = "fd5f:e1a2:4f0c:0:b065:3fff:fec9:6b10/64";
in

{ pkgs, lib, ... }:
{
  name = "containers-ipv6-slaac";
  meta = {
    maintainers = with lib.maintainers; [
      lschuermann
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      networking.useNetworkd = true;
      networking.useDHCP = false;

      systemd.network.netdevs."br0".netdevConfig = {
        Name = "br0";
        Kind = "bridge";
        MACAddress = hostMAC;
      };

      systemd.network.networks."br0" = {
        name = "br0";

        networkConfig = {
          IPv6SendRA = true;

          # Disable privacy extensions, which would assign the host a random
          # address in the ULA prefix (defeating the purpose of setting the
          # bridge's `MACAddress` to assign it a stable address explicitly):
          IPv6PrivacyExtensions = false;
        };

        ipv6SendRAConfig = {
          # We assign addresses exclusively through SLAAC, not via DHCPv6:
          Managed = false;

          # This router is not a default gateway, as we don't have an IPv6
          # upstream. This causes no default route to be inserted with the RA.
          RouterLifetimeSec = 0;
          UplinkInterface = ":none";
        };

        ipv6Prefixes = [
          {
            # Assign addresses out of the configured ULA prefix:
            Prefix = ulaPrefix;
            AddressAutoconfiguration = true;

            # All other addresses in this subnet are reachable via Layer 2 (don't
            # need to go through the host as a router):
            OnLink = true;

            # Assign the host an address out of this subnet:
            Assign = true;
            # Use MAC address as the basis for SLAAC address generation:
            Token = "eui64";
          }
        ];

        # The router doesn't advertise itself as a default gateway, so we
        # announce our ULA prefix explicitly:
        ipv6RoutePrefixes = [
          {
            Route = ulaPrefix;
            LifetimeSec = 1800;
          }
        ];

      };

      containers.webserver = {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        localMacAddress = containerMAC;

        config = {
          networking.useNetworkd = true;
          networking.useHostResolvConf = false;

          systemd.network.networks."eth0" = {
            name = "eth0";
            DHCP = "no";

            # Assign an IPv6 address out of the host-advertised prefix, disable
            # privacy extensions (which would assign a random address in the
            # announced prefix, defeating the purpose of setting the
            # `localMacAddress` option to assign the container a stable
            # address):
            networkConfig = {
              IPv6AcceptRA = true;
              IPv6PrivacyExtensions = false;
            };
          };

          services.httpd.enable = true;
          networking.firewall.allowedTCPPorts = [ 80 ];
        };
      };
    };

  testScript = ''
    import time

    machine.wait_for_unit("default.target")
    assert "webserver" in machine.succeed("nixos-container list")

    with subtest("Start the webserver container"):
        assert "up" in machine.succeed("nixos-container status webserver")

    with subtest("veth in container has correct MAC address"):
        assert "${containerMAC}" in machine.succeed(
            "nixos-container run webserver -- ip link show eth0",
        )

    with subtest("Host gets assigned IPv6 in and route for ULA prefix"):
        # This is done by systemd-network internally, so should be available
        # instantly:
        assert "${hostSLAACv6}" in machine.succeed(
            "ip addr show br0"
        )
        assert "${ulaPrefix}" in machine.succeed(
            "ip -6 route show"
        )

    with subtest("Container gets assigned IPv6 in and route for ULA prefix"):
        # Give the container a few seconds to assign itself a v6 out of and set
        # up a route for the ULA prefix from the router advertisement:
        for _ in range(3):
            iface_ips = machine.succeed(
                "nixos-container run webserver -- ip addr show eth0",
            )
            v6_routes = machine.succeed(
                "nixos-container run webserver -- ip -6 route show",
            )
            if "${containerSLAACv6}" in iface_ips and "${ulaPrefix}" in v6_routes:
                break
            else:
                time.sleep(1)
        else:
            raise AssertionError(
                "Container either did not assign itself the expected SLAAC "
                + "v6 out of the announced ULA prefix (${containerSLAACv6}) "
                + "or did not assign a route for the URL prefix "
                + f"(${ulaPrefix}).\n\n==> ip addr show eth0:\n{iface_ips}"
                + f"\n\n==> ip -6 route show:\n{v6_routes}"
            )

    ip6 = "${containerSLAACv6}".split("/")[0]

    with subtest("Container reponds to ICMPv6 echo requests"):
        # IPv6 ND can take some time, so try at most 30 times:
        for i in range(30):
            print(f"Sending ICMP echo request, attempt #{i}")
            exit_status, _out = machine.execute(f"ping -n -c 1 {ip6}")
            if exit_status == 0:
                break
            else:
                time.sleep(1)
        else:
            raise AssertionError("Container doesn't respond to pings!")

    with subtest("Container responds to HTTP requests"):
        machine.succeed(f"curl --fail http://[{ip6}]/ > /dev/null")

    # Destroying a declarative container should fail.
    machine.fail("nixos-container destroy webserver")
  '';
}
