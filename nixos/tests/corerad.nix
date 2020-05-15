import ./make-test-python.nix (
  {
    nodes = {
      router = {config, pkgs, ...}: { 
        config = {
          # This machines simulates a router with IPv6 forwarding and a static IPv6 address.
          boot.kernel.sysctl = {
            "net.ipv6.conf.all.forwarding" = true;
          };
          networking.interfaces.eth1 = {
            ipv6.addresses = [ { address = "fd00:dead:beef:dead::1"; prefixLength = 64; } ];
          };
          services.corerad = {
            enable = true;
            # Serve router advertisements to the client machine with prefix information matching
            # any IPv6 /64 prefixes configured on this interface.
            configFile = pkgs.writeText "corerad.toml" ''
              [[interfaces]]
              name = "eth1"
              advertise = true
                [[interfaces.prefix]]
                prefix = "::/64"
            '';
          };
        };
      };
      client = {config, pkgs, ...}: {
        # Use IPv6 SLAAC from router advertisements, and install rdisc6 so we can
        # trigger one immediately.
        config = {
          boot.kernel.sysctl = {
            "net.ipv6.conf.all.autoconf" = true;
          };
          environment.systemPackages = with pkgs; [
            ndisc6
          ];
        };
      };
    };

    testScript = ''
      start_all()

      with subtest("Wait for CoreRAD and network ready"):
          # Ensure networking is online and CoreRAD is ready.
          router.wait_for_unit("network-online.target")
          client.wait_for_unit("network-online.target")
          router.wait_for_unit("corerad.service")

          # Ensure the client can reach the router.
          client.wait_until_succeeds("ping -c 1 fd00:dead:beef:dead::1")

      with subtest("Verify SLAAC on client"):
          # Trigger a router solicitation and verify a SLAAC address is assigned from
          # the prefix configured on the router.
          client.wait_until_succeeds("rdisc6 -1 -r 10 eth1")
          client.wait_until_succeeds(
              "ip -6 addr show dev eth1 | grep -q 'fd00:dead:beef:dead:'"
          )

          addrs = client.succeed("ip -6 addr show dev eth1")

          assert (
              "fd00:dead:beef:dead:" in addrs
          ), "SLAAC prefix was not found in client addresses after router advertisement"
          assert (
              "/64 scope global temporary" in addrs
          ), "SLAAC temporary address was not configured on client after router advertisement"
    '';
  })
