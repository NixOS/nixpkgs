import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-next-nat";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    client = {
      networking.useNetworkd = true;
      systemd.network.networks."10-eth1" = {
        matchConfig.Name = "eth1";
        address = [ "fd23::1/64" "192.168.1.1/24" ];
        routes = [
          { routeConfig.Destination = "fd24::1/64"; }
        ];
      };

      # Check for NAT by making sure that only the host's addresses can ping
      # this machine.
      networking.firewall.extraCommands = ''
        iptables -A INPUT -p icmp -s 192.168.1.2 -j ACCEPT
        ip6tables -A INPUT -p icmp -s fd24::1 -j ACCEPT
        ip46tables -A INPUT -p icmp -j REJECT
      '';
    };

    host = {
      networking.useNetworkd = true;
      systemd.network.networks."10-eth1" = {
        matchConfig.Name = "eth1";
        address = [ "fd24::1/64" "192.168.1.2/24" ];
        networkConfig.IPForward = "yes";
        routes = [
          { routeConfig.Destination = "fd23::1/64"; }
        ];
      };

      networking.firewall.allowedUDPPorts = [ 53 67 68 546 547 ];

      nixos.containers.instances = with lib; mapAttrs (const (nat: {
        network = lib.genAttrs [ "v4" "v6" ] (const { inherit nat; });
      })) {
        withnat = true;
        nonat = false;
      };
    };
  };

  testScript = ''
    start_all()

    host.wait_for_unit("network-online.target")
    host.wait_for_unit("machines.target")
    client.wait_for_unit("network-online.target")

    with subtest("Confirm connectivity between host & client (precondition)"):
        host.succeed("ping -c4 >&2 192.168.1.1")
        client.succeed("ping -c4 >&2 192.168.1.2")
        host.succeed("ping -c4 >&2 fd23::1")
        client.succeed("ping -c4 >&2 fd24::1")

    with subtest("Confirm IPv4 NAT"):
        host.succeed("systemd-run -M withnat --pty --quiet -- /bin/sh --login -c 'ping -c4 >&2 192.168.1.1'")
        host.fail("systemd-run -M nonat --pty --quiet -- /bin/sh --login -c 'ping -c4 >&2 192.168.1.1'")
        host.succeed("systemd-run -M withnat --pty --quiet -- /bin/sh --login -c 'ping -c4 >&2 fd23::1'")
        host.fail("systemd-run -M nonat --pty --quiet -- /bin/sh --login -c 'ping -c4 >&2 fd23::1'")

    host.shutdown()
    client.shutdown()
  '';
})
