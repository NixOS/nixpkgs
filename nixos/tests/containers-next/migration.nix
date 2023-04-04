import ../make-test-python.nix ({ pkgs, lib, ... }: let
  hostIP = "192.168.1.1";
  containerIP = "192.168.1.5";
  clientIP = "192.168.1.23";

  legacy = { pkgs, ... }: {
    networking.macvlans.mv-eth1-host = {
      interface = "eth1";
      mode = "bridge";
    };
    networking.interfaces.eth1.ipv4.addresses = lib.mkForce [];
    networking.interfaces.mv-eth1-host = {
      ipv4.addresses = [ { address = "${hostIP}"; prefixLength = 24; } ];
    };
    containers.test1 = {
      macvlans = [ "eth1" ];

      config = {
        networking.interfaces.mv-eth1 = {
          ipv4.addresses = [ { address = containerIP; prefixLength = 24; } ];
        };
        services.nginx = {
          enable = true;
          virtualHosts."localhost" = {
            listen = [
              { addr = "${containerIP}"; port = 80; ssl = false; }
            ];
          };
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    };
    containers.test2 = {
      privateNetwork = true;
      hostAddress = "10.231.136.1";
      localAddress = "10.231.136.2";
      config = {};
    };
  };
  networkd = { pkgs, ... }: {
    networking = {
      useNetworkd = true;
      useDHCP = false;
      interfaces.eth0.useDHCP = true;
    };

    # Also check if old containers can co-exist
    containers.test3 = {
      privateNetwork = true;
      hostAddress = "10.232.13.1";
      localAddress = "10.232.13.2";
      config = {};
    };

    # Corresponding networkd config for macvlans
    systemd.nspawn.test1.networkConfig.MACVLAN = "eth1";
    systemd.network.networks."40-eth0".linkConfig.RequiredForOnline = "no";
    systemd.network.networks."40-eth1" = {
      matchConfig.Name = "eth1";
      networkConfig.DHCP = lib.mkForce "yes";
      dhcpConfig.UseDNS = "no";
      networkConfig.MACVLAN = "mv-eth1-host";
      linkConfig.RequiredForOnline = "no";
      address = lib.mkForce [];
      addresses = lib.mkForce [];
    };
    systemd.network.networks."20-mv-eth1-host" = {
      matchConfig.Name = "mv-eth1-host";
      networkConfig.IPForward = "yes";
      dhcpV4Config.ClientIdentifier = "mac";
      linkConfig.RequiredForOnline = "no";
      address = lib.mkForce [
        "${hostIP}/24"
      ];
    };
    systemd.network.netdevs."20-mv-eth1-host" = {
      netdevConfig = {
        Name = "mv-eth1-host";
        Kind = "macvlan";
      };
      extraConfig = ''
        [MACVLAN]
        Mode=bridge
      '';
    };

    nixos.containers.instances = {
      # Corresponding config for test1 with the new interface
      test1.system-config = {
        systemd.network = {
          networks."10-mv-eth1" = {
            matchConfig.Name = "mv-eth1";
            address = [ "${containerIP}/24" ];
          };
          netdevs."10-mv-eth1" = {
            netdevConfig.Name = "mv-eth1";
            netdevConfig.Kind = "veth";
          };
        };
        services.nginx = {
          enable = true;
          virtualHosts."localhost" = {
            listen = [
              { addr = "${containerIP}"; port = 80; ssl = false; }
            ];
          };
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
      # Config for test2 with the new interface
      test2 = {
        network.v4.static.containerPool = [ "10.231.136.2/24" ];
        network.v4.static.hostAddresses = [ "10.231.136.1/24" ];
      };
    };
  };
in {
  name = "containers-migration";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    machine = { pkgs, ... }: {
      networking.primaryIPAddress = lib.mkForce hostIP;

      # Switching network stacks entirely isn't really possible. So just reboot
      # (to simulate the update, a bootloader which boots into the new config is needed).
      virtualisation.useBootLoader = true;
      virtualisation.persistBootDevice = true;
      boot.loader = {
        efi.canTouchEfiVariables = false;
        grub = {
          enable = true;
          version = 2;
          efiInstallAsRemovable = true;
          efiSupport = true;
          device = "nodev";
        };
      };

      imports = [ legacy ];

      specialisation.networkd.configuration = { pkgs, ... }: {
        imports = [ networkd ];
      };
    };

    client = { pkgs, lib, ... }: {
      networking.primaryIPAddress = lib.mkForce clientIP;
      virtualisation.vlans = [ 1 ];
      networking = {
        useDHCP = false;
        interfaces.eth0.useDHCP = true;
        interfaces.eth1.useDHCP = true;
      };
    };
  };

  testScript = { nodes, ... }: let
    switchTo = sp: "${nodes.machine.config.system.build.toplevel}/specialisation/${sp}/bin/switch-to-configuration boot --install-bootloader";
  in ''
    client.start()
    machine.start()

    client.wait_for_unit("network-online.target")
    machine.wait_for_unit("network-online.target")

    # For some reason /nix/var/nix/db is missing when using Grub as VM bootloader. Running
    # this ensures it's created.
    machine.succeed("nix-env -q")
    machine.succeed("nixos-container start test1")
    machine.succeed("nixos-container start test2")

    with subtest("Test state before migration"):
        machine.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        machine.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        machine.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")
        machine.wait_until_succeeds("ping -c3 10.231.136.2 >&2")

        client.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        client.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        client.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")

        machine.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'echo foobar >/root/tmpfile; sleep 1'"
        )
        machine.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'cat /root/tmpfile | grep foobar'"
        )
        machine.succeed("test 0 = $(stat /var/lib/nixos-containers/test2/root/tmpfile -c %u)")
        machine.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'test 0 = $(stat /root/tmpfile -c %u)'"
        )

    with subtest("Prepare migration"):
        machine.succeed("machinectl poweroff test1")
        machine.succeed("machinectl poweroff test2")
        machine.wait_until_unit_stops("container@test1")
        machine.wait_until_unit_stops("container@test2")

        machine.succeed("mkdir -p /var/lib/machines")
        machine.succeed("mv /var/lib/nixos-containers/{test1,test2} /var/lib/machines")
        machine.succeed("test -e /var/lib/machines/test1")
        machine.succeed("test -e /var/lib/machines/test2")

    with subtest("Activate new configuration"):
        machine.succeed("${switchTo "networkd"}")

        machine.shutdown()
        machine.start()
        machine.wait_for_unit("network-online.target")

        machine.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        machine.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        machine.wait_until_succeeds("ping -c3 10.231.136.2 >&2")
        client.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        client.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        client.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")

        machine.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'cat /root/tmpfile | grep foobar'"
        )
        machine.succeed("test 60000 -lt $(stat /var/lib/machines/test2/root/tmpfile -c %u)")
        machine.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'test 0 = $(stat /root/tmpfile -c %u)'"
        )

        machine.succeed("nixos-container start test3")
        machine.succeed("ping 10.232.13.1 -c3 >&2")
        machine.succeed("ping 10.232.13.2 -c3 >&2")

    machine.succeed("machinectl poweroff test1")
    machine.succeed("machinectl poweroff test2")

    client.shutdown()
    machine.shutdown()
  '';
})
