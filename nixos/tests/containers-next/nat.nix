import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-next-nat";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    client = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.tcpdump ];
      # Check for NAT by making sure that only the host's addresses can ping
      # this machine.
      networking.firewall.extraCommands = ''
        iptables -A INPUT -p icmp -s 192.168.1.2 -j ACCEPT
        ip6tables -A INPUT -p icmp -s fd24::1 -j ACCEPT
        ip46tables -A INPUT -p icmp -j REJECT
      '';
      networking.useNetworkd = true;
      systemd.network.networks."10-eth1" = {
        matchConfig.Name = "eth1";
        networkConfig = {
          IPForward = "yes";
          IPv6AcceptRA = "yes";
        };
        address = [ "fd23::1/64" "192.168.1.1/24" ];
        routes = [
          { routeConfig.Destination = "fd24::1/64"; }
        ];
      };
    };
    host = {
      systemd.network.networks."10-eth1" = {
        matchConfig.Name = "eth1";
        address = [ "fd24::1/64" "192.168.1.2/24" ];
        networkConfig.IPv6ProxyNDP = "yes";
        networkConfig = {
          IPForward = "yes";
          IPv6AcceptRA = "yes";
          DNS = "fd24::1";
        };
        routes = [
          { routeConfig.Destination = "fd23::1/64"; }
        ];
      };
      networking.firewall.allowedUDPPorts = [ 53 67 68 546 547 ];
      networking.useNetworkd = true;
      nixos.containers.instances = {
        withnat = {
          network = {
            v4.nat = true;
            v6.nat = true;
          };
        };
        nonat = {
          network = {
            v4.nat = false;
            v6.nat = false;
          };
        };
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
