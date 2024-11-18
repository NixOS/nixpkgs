# Test ICMPTX.
# In a real deployment, you should use an encryption layer like WireGuard to encrypt and authenticate the data.
# Putting the program in a NixOS container with the Ethernet interface and then moving the tun0 interface outside of the container seems like a good idea for better isolation.
{
  recurseIntoAttrs,
  runTest,
}:
let
  mkTest =
    { useNftables }:
    { lib, ... }:
    {
      name = "ICMPTX-${if useNftables then "nftables" else "iptables"}";

      meta = with lib.maintainers; {
        maintainers = [ Luflosi ];
      };

      defaults =
        { ... }:
        {
          networking.nftables.enable = useNftables;

          networking.firewall.allowPing = true;

          # Using networkd is required for this NixOS module.
          networking.useNetworkd = true;

          virtualisation.interfaces.eth1 = {
            vlan = 1;
            assignIP = false;
          };

          # The tunnel does not support ICMPv6 anyways, so remove some noise from the packet capture
          systemd.network.networks."40-eth1".networkConfig.LinkLocalAddressing = "no";
        };

      nodes = {
        server =
          { config, pkgs, ... }:
          {
            networking.firewall.trustedInterfaces = [ config.services.icmptx.server.tun ];

            networking.interfaces.eth1.ipv4.addresses = lib.singleton {
              address = "1.2.3.4";
              prefixLength = 24;
            };

            # Test using the NixOS-style IP address configuration here
            networking.interfaces.${config.services.icmptx.server.tun} = {
              # Path MTU minus IPv4 header size minus ICMP header size.
              # If your path MTU is smaller than this, for example because your internet connection is using PPPoE, then you need to adjust this.
              mtu = 1500 - 20 - 8;

              ipv4.addresses = lib.singleton {
                address = "10.0.3.1";
                prefixLength = 24;
              };
              ipv6.addresses = lib.singleton {
                address = "2001:db8::1";
                prefixLength = 64;
              };
            };

            services.icmptx.server = {
              enable = true;
              serverIPv4 = "1.2.3.4";
            };

            # test resource: accessible only via tunnel
            services.openssh = {
              enable = true;
              openFirewall = false;
            };
          };

        client =
          { config, pkgs, ... }:
          {
            networking.interfaces.eth1.ipv4.addresses = lib.singleton {
              address = "1.2.3.5";
              prefixLength = 24;
            };

            # Test using the networkd-style IP address configuration here
            systemd.network.networks."40-${config.services.icmptx.server.tun}" = {
              name = config.services.icmptx.server.tun;
              networkConfig = {
                DHCP = "no";
                Address = [
                  "10.0.3.2/24"
                  "2001:db8::2/64"
                ];
              };

              # Path MTU minus IPv4 header size minus ICMP header size.
              # If your path MTU is smaller than this, for example because your internet connection is using PPPoE, then you need to adjust this.
              linkConfig.MTUBytes = 1500 - 20 - 8;
            };

            services.icmptx.client = {
              enable = true;
              serverIPv4 = "1.2.3.4";
            };

            environment.systemPackages = with pkgs; [
              lsof
              nagiosPluginsOfficial
              tcpdump
            ];
          };
      };

      testScript = ''
        import os

        def start_packet_capture(machine):
          machine.succeed("tcpdump -n -i eth1 -w /tmp/eth1.pcap 2>/tmp/stderr-eth1 >/dev/null & echo $! >/tmp/pid-eth1")
          machine.succeed("tcpdump -n -i tun0 -w /tmp/tun0.pcap 2>/tmp/stderr-tun0 >/dev/null & echo $! >/tmp/pid-tun0")

          # Wait for tcpdump to start recording
          machine.succeed("sleep 1")


        def stop_packet_capture(machine):
          # TODO: find a better way to wait for wireshark to be done capturing
          machine.succeed("sleep 1")

          # Send a signal to tcpdump
          machine.succeed('kill -s SIGTERM "$(</tmp/pid-eth1)"')
          machine.succeed('kill -s SIGTERM "$(</tmp/pid-tun0)"')

          # Wait for tcpdump to stop
          machine.succeed('tail --pid="$(</tmp/pid-eth1)" -f /dev/null')
          machine.succeed('tail --pid="$(</tmp/pid-tun0)" -f /dev/null')

          # Print stderr of tcpdump
          machine.succeed("cat /tmp/stderr-eth1 >&2")
          machine.succeed("cat /tmp/stderr-tun0 >&2")

          # Make sure no packets were dropped by the kernel
          assert "0 packets dropped by kernel" in machine.succeed("cat /tmp/stderr-eth1").splitlines(), "The kernel dropped some packets"
          assert "0 packets dropped by kernel" in machine.succeed("cat /tmp/stderr-tun0").splitlines(), "The kernel dropped some packets"

          # Copy packet captures to the output for easy debugging
          # This output is unfortunately not reproducible
          machine.copy_from_vm("/tmp/eth1.pcap")
          machine.copy_from_vm("/tmp/tun0.pcap")

          eth1_size = os.stat(machine.out_dir / "eth1.pcap").st_size
          tun0_size = os.stat(machine.out_dir / "tun0.pcap").st_size
          assert eth1_size >= tun0_size, "The packet capture of the tun0 interface was larger than that of the eth1 interface. This indicates that ping packets were sent into the ping tunnel, resulting in an infinite loop"


        def check_ping(machine, ip_addr):
          # Send two pings so the ping program runs long enough to see any potential duplicates
          result = machine.succeed(f"ping -c 2 {ip_addr}")
          assert "2 packets transmitted, 2 received, 0% packet loss" in result, "Did not receive exactly one ping response per request:\n" + result


        start_all()

        client.wait_for_unit("icmptx-client.service")
        server.wait_for_unit("icmptx-server.service")
        server.wait_for_unit("sshd.service")

        client.log(client.succeed(
          "systemd-analyze security icmptx-client.service | grep -v '✓'"
        ))

        # Wait for interface to exist and have an IP address
        client.wait_until_succeeds("ip addr show dev tun0 | grep inet")
        server.wait_until_succeeds("ip addr show dev tun0 | grep inet")

        start_packet_capture(client)

        client.succeed("ip a >&2")
        client.succeed("ip route >&2")
        server.succeed("ip a >&2")
        server.succeed("ip route >&2")

        with subtest("Normal ping outside of the tunnel still works"):
          check_ping(client, "1.2.3.4")
          check_ping(server, "1.2.3.5")

        with subtest("Establish an SSH connection via the tunnel"):
          client.succeed("check_ssh -H 10.0.3.1")
          client.succeed("check_ssh -H 2001:db8::1")

        with subtest("IPv6 Ping inside the tunnel works"):
          check_ping(client, "2001:db8::1")
          check_ping(server, "2001:db8::2")

        with subtest("IPv4 Ping inside the tunnel fails"):
          client.fail("ping -c 1 10.0.3.1 >&2")
          server.fail("ping -c 1 10.0.3.2 >&2")

        stop_packet_capture(client)

        # Check that ICMPTX is still running
        client.require_unit_state("icmptx-client.service")
        server.require_unit_state("icmptx-server.service")
      '';
    };
in
recurseIntoAttrs {
  icmptx-nftables = runTest (mkTest {
    useNftables = true;
  });
  icmptx-iptables = runTest (mkTest {
    useNftables = false;
  });
}
