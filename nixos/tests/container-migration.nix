import ./make-test-python.nix ({ pkgs, lib, ... }: let
  hostIP = "192.168.1.1";
  containerIP = "192.168.1.5";
  clientIP = "192.168.1.23";

  base = { lib, ... }: {
    networking.primaryIPAddress = lib.mkForce hostIP;

    # Switching network stacks entirely isn't really possible. So just reboot
    # (to simulate the update, a bootloader which boots into the new config is needed).
    virtualisation.useBootLoader = true;
    virtualisation.persistentBootDisk = true;
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
  };
in {
  name = "container-migration";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    legacy = { pkgs, ... }: {
      imports = [ base ];

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

    new = { pkgs, lib, ... }: {
      imports = [ base ];

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
        test1.config = {
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
        test2 = {
          network.v4.static.containerPool = [ "10.231.136.2/24" ];
          network.v4.static.hostAddresses = [ "10.231.136.1/24" ];
        };
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

  skipLint = true;

  testScript = { nodes, ... }: let
     new = nodes.new.config.system.build.toplevel;
  in ''
    client.start()
    legacy.start()

    client.wait_for_unit("network-online.target")
    legacy.wait_for_unit("network-online.target")

    # For some reason /nix/var/nix/db is missing when using Grub as VM bootloader. Running
    # this ensures it's created.
    legacy.succeed("nix-env -q")
    legacy.succeed("nixos-container start test1")
    legacy.succeed("nixos-container start test2")

    with subtest("Test state before migration"):
        legacy.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        legacy.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        legacy.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")
        legacy.wait_until_succeeds("ping -c3 10.231.136.2 >&2")

        client.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        client.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        client.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")

        legacy.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'echo foobar >/root/tmpfile; sleep 1'"
        )
        legacy.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'cat /root/tmpfile | grep foobar'"
        )

    with subtest("Prepare migration"):
        legacy.succeed("machinectl poweroff test1")
        legacy.succeed("machinectl poweroff test2")
        legacy.wait_until_unit_stops("container@test1")
        legacy.wait_until_unit_stops("container@test2")

        legacy.succeed("mkdir -p /var/lib/machines")
        legacy.succeed("mv /var/lib/containers/{test1,test2} /var/lib/machines")
        legacy.succeed("test -e /var/lib/machines/test1")
        legacy.succeed("test -e /var/lib/machines/test2")

    with subtest("Activate new configuration"):
        legacy.succeed(
            "${new}/bin/switch-to-configuration boot --install-bootloader"
        )

        legacy.shutdown()
        legacy.start()
        legacy.wait_for_unit("network-online.target")

        legacy.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        legacy.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        legacy.wait_until_succeeds("ping -c3 10.231.136.2 >&2")
        client.wait_until_succeeds("ping -c3 ${hostIP} >&2")
        client.wait_until_succeeds("ping -c3 ${containerIP} >&2")
        client.succeed("curl -sSf ${containerIP} | grep -q 'Welcome to nginx'")

        legacy.succeed(
            "systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'cat /root/tmpfile | grep foobar'"
        )

        legacy.succeed("nixos-container start test3")
        legacy.succeed("ping 10.232.13.1 -c3 >&2")
        legacy.succeed("ping 10.232.13.2 -c3 >&2")

    legacy.succeed("machinectl poweroff test1")
    legacy.succeed("machinectl poweroff test2")

    client.shutdown()
    legacy.shutdown()
  '';
})
