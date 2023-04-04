import ../make-test-python.nix ({ pkgs, lib, ... }: let
  inherit (import ../ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;
in {
  name = "container-tests";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  # Just an arbitrary `client'-machine to test the public endpoints
  # of containers hosted on a different server.
  nodes.client = { pkgs, ... }: {
    virtualisation.vlans = [ 1 ];
    networking.useNetworkd = true;
    networking.firewall.extraCommands = ''
      ip46tables -A INPUT -i eth1 -j ACCEPT
    '';
    systemd.network.networks."10-eth1" = {
      matchConfig.Name = "eth1";
      address = [ "fd23::1/64" ];
      routes = [
        { routeConfig.Destination = "fd24::1/64"; }
      ];
    };
  };

  # Demo server which hosts nspawn machines.
  nodes.server = { pkgs, lib, config, ... }: {
    ### Basic networking parts to get the setup up and running

    virtualisation.vlans = [ 1 ];
    networking = {
      firewall.allowedTCPPorts = [ 80 ];
      useNetworkd = true;
    };

    # `server' is supposed to use `fd24::1/64`. However the test network in QEMU
    # doesn't take care of neighbour resolution via NDP. To work around this, `server'
    # proxies NDP traffic of container IPs.
    services.ndppd = {
      enable = true;
      proxies.eth1.rules."fd24::2/64" = {};
    };

    # Needed to make sure that the DHCPServer of `systemd-networkd' properly works and
    # can assign IPv4 addresses to containers.
    time.timeZone = "Europe/Berlin";
    networking.firewall.allowedUDPPorts = [ 53 67 68 546 547 ];

    # Local authoritative DNS server. Used to confirm how DNS is handled by nspawn by default.
    services.bind = {
      enable = true;
      extraOptions = "empty-zones-enable no;";
      listenOnIpv6 = [ "fd24::1" ];
      cacheNetworks = [ "fd24::/64" ];
      zones = [
        { name = ".";
          master = true;
          extraConfig = "allow-query { any; };";
          file = pkgs.writeText "root.zone" ''
            $TTL 3600
            . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
            . IN NS ns.example.org.

            ns.example.org. IN AAAA fd24::1
            client.lan. IN AAAA fd23::1

            1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.4.2.d.f.ip6.arpa. 1h IN PTR ns.example.org.
          '';
        }
      ];
    };

    # Reverse-proxy to expose the contents of container0:80
    services.nginx = {
      enable = true;
      virtualHosts."localhost" = {
        locations."/".proxyPass = "http://container0:80";
      };
    };

    # IPv4/IPv6 connectivity in the test network
    systemd.network.networks."10-eth1" = {
      matchConfig.Name = "eth1";
      address = [ "fd24::1/64" ];
      networkConfig = {
        IPForward = "yes";
        DNS = "fd24::1";
      };
      routes = [
        { routeConfig.Destination = "fd23::1/64"; }
      ];
    };

    ### Eval test to make sure that we can query options of containers during evaluation

    environment.etc."container-exposed-nginx-hosts".text = with lib;
      concatStringsSep " "
        (attrNames config.nixos.containers.instances.container0.system-config.config.services.nginx.virtualHosts);

    ### Test containers + corresponding zones

    # container0: use ULA IPv6 addr and let nginx listen to it. Used
    #  to demonstrate that containers can serve to the outer network.
    systemd.network.networks."20-ve-container0".routes = [
      { routeConfig.Destination = "fd24::2"; }
    ];
    nixos.containers.instances.container0 = {
      network.v6.static = {
        containerPool = [ "fd24::2/64" ];
        hostAddresses = [ "fd24::3/64" ];
      };
      network.v6.addrPool = lib.mkForce [];
      credentials = [
        { id = "snens";
          path = "${pkgs.writeText "totallysecret" "abc"}";
        }
      ];
      system-config = { pkgs, ... }: {
        networking.firewall.allowedTCPPorts = [ 80 ];
        systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
        services.nginx = {
          enable = true;
          virtualHosts."localhost" = {
            listen = [
              { addr = "[fd24::2]"; port = 80; ssl = false; }
            ];
          };
        };
      };
    };

    # container1: mount only needed store-paths into the container rather than sharing the full store
    #  and to test DNS from the host network.
    systemd.network.networks."20-ve-container1".networkConfig.DNS = "fd24::1";
    nixos.containers.instances.container1 = {
      sharedNix = false;
      activation.strategy = "restart";
      nixpkgs = ../../..;
      zone = "foo";
      network.v6.addrPool = lib.mkForce [];
      network.v4.addrPool = lib.mkForce [];
      network.v4.static.containerPool = [ "10.100.200.10/24" ];
      system-config = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello pkgs.nmap pkgs.dnsutils ];
        systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
        systemd.network.networks."20-host0".networkConfig.DNS = "fd24::1";
      };
    };

    # container2: to test virtual zones and special resolv.conf behavior.
    nixos.containers.zones.foo.hostAddresses = [ "10.100.200.1/24" ];
    systemd.nspawn.container2.execConfig.ResolvConf = "bind-host";
    nixos.containers.instances.container2 = {
      zone = "foo";
      network.v6.addrPool = lib.mkForce [];
      network.v4.addrPool = lib.mkForce [];
      network.v4.static.containerPool = [ "10.100.200.11/24" ];
    };

    # publicnet: share the network with the host entirely, i.e. no new namespace.
    nixos.containers.instances.publicnet = {};
    systemd.nspawn.publicnet.networkConfig.VirtualEthernet = "no";

    # ephemeral: containers with state cleared after a reboot.
    nixos.containers.instances.ephemeral = {
      ephemeral = true;
      network = {};
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("machines.target")
    server.wait_for_unit("multi-user.target")
    server.wait_for_unit("network-online.target")

    client.wait_for_unit("network-online.target")
    client.wait_for_unit("multi-user.target")

    client.wait_for_unit("systemd-networkd-wait-online.service")

    server.wait_for_unit("systemd-nspawn@container0")
    server.wait_for_unit("systemd-nspawn@ephemeral")
    server.wait_for_unit("systemd-networkd-wait-online.service")

    with subtest("Static networking"):
        server.execute("ping fd24::1 -c3 >&2")
        server.execute("ping fd24::2 -c3 >&2 || true")
        client.execute("ping fd24::1 -c3 >&2 || true")
        server.wait_until_succeeds("ping -4 container0 -c3 >&2")
        server.wait_until_succeeds("ping -6 container0 -c3 >&2")

        server.wait_until_succeeds(
            "curl -sSf 'http://[fd24::2]' | grep -q 'Welcome to nginx'"
        )
        server.succeed("curl -sSf 'http://localhost' | grep -q 'Welcome to nginx'")

        server.succeed(
            "systemd-run -M container0 --pty --quiet -- /bin/sh --login -c 'test -w /var/empty'"
        )

        client.wait_until_succeeds("ping fd24::2 -c3 >&2")
        client.succeed("curl -sSf 'http://[fd24::2]' | grep -q 'Welcome to nginx'")

        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.wait_until_succeeds(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil root@fd24::2 true"
        )

    with subtest("machinectl reboot"):
        server.succeed("machinectl reboot container0")
        server.wait_until_succeeds("ping -4 container0 -c3 >&2")

    with subtest("Dynamic networking"):
        # Test IPv4LL, DHCP & SLAAC addrs reachability.
        server.wait_until_succeeds("ping -6 -c3 container1 >&2")
        server.wait_until_succeeds("ping -c3 10.100.200.1 >&2")
        server.wait_until_succeeds("ping -c3 10.100.200.10 >&2")

        server.wait_until_succeeds("ping -4 -c3 container1 >&2")

        server.succeed("machinectl status container1 | grep '   fd' | xargs -I % ping % -c3")
        server.succeed(
            "machinectl status ephemeral | grep '192.168' | cut -d: -f2 | xargs ping -c3"
        )

    with subtest("DNS"):
        server.succeed("resolvectl query client.lan | grep fd23::1")
        server.succeed("ping -c3 client.lan >&2")
        server.succeed(
            "systemd-run -M container1 --pty --quiet -- /bin/sh --login -c 'resolvectl query client.lan | grep fd23::1' >&2"
        )

        server.succeed(
            "systemd-run -M container2 --pty --quiet /bin/sh --login -c 'resolvectl query container2 | grep 127.0.0.2' >&2"
        )

    with subtest("Ephemeral"):
        server.wait_until_succeeds("ping ephemeral -4 -c3 >&2")
        server.wait_until_succeeds("ping ephemeral -6 -c3 >&2")
        server.fail(
            "systemd-run -M ephemeral --pty --quiet -- /bin/sh --login -c 'test -e /foo'"
        )

        server.succeed("machinectl poweroff ephemeral")
        server.wait_until_unit_stops("systemd-nspawn@ephemeral")
        server.succeed("machinectl start ephemeral")

        server.wait_until_succeeds("ping ephemeral -6 -c3 >&2")

    with subtest("Public networking"):
        server.fail("ip a | grep publicnet")

        # In case of no private ethernet the container inherits the networking
        # from the host.
        ipdata = server.succeed(
            "systemd-run -M publicnet --pty --quiet -- /bin/sh --login -c 'ip --json a show eth1 >&2'"
        )

        import json

        data = json.loads(ipdata)[0]
        assert any(
            x["local"] == "fd24::1" for x in data["addr_info"] if x["family"] == "inet6"
        )

        server.succeed(
            "systemd-run -M publicnet --pty --quiet -- /bin/sh --login -c 'ping fd23::1 -c3 >&2'"
        )

    with subtest("Credentials"):
        server.succeed(
            "systemd-run -M container0 --pty --quiet /bin/sh --login -c 'test -e /run/host/credentials/snens'"
        )

    with subtest("Proper sudo"):
        server.succeed(
            "systemd-run -M container0 --pty --quiet /bin/sh --login -c 'sudo -u root /run/current-system/sw/bin/ls'"
        )

    with subtest("Declarative container config is introspectable"):
        server.succeed(
            "test localhost = $(cat /etc/container-exposed-nginx-hosts)"
        )

    server.succeed("machinectl poweroff container0")
    server.succeed("machinectl poweroff container1")
    server.succeed("machinectl poweroff publicnet")
    server.succeed("machinectl poweroff ephemeral")

    server.wait_until_unit_stops("systemd-nspawn@container0")
    server.wait_until_unit_stops("systemd-nspawn@container1")

    client.shutdown()
    server.shutdown()
  '';
})
