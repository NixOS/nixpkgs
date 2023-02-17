import ../make-test-python.nix ({ pkgs, lib, ... }: let
  keypairs = { inherit (import ../wireguard/snakeoil-keys.nix) peer0 peer1; };

  base = { config, pkgs, ... }: {
    environment.systemPackages = [ pkgs.tcpdump pkgs.tmux ];
    networking = {
      useNetworkd = true;
      useDHCP = false;
      interfaces.eth0.useDHCP = true;
      firewall.allowedUDPPorts = [ 23542 ];
    };
    systemd.network = {
      netdevs."20-wg0" = {
        netdevConfig = { Kind = "wireguard"; Name = "wg0"; };
        wireguardConfig = {
          ListenPort = 23542;
          PrivateKeyFile = pkgs.writeText
            "wg0-priv"
            keypairs.${config.networking.hostName}.privateKey;
        };
      };
      networks."20-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig = {
          IPForward = "yes";
          DHCP = "no";
          DNS = "192.168.20.2";
        };
      };
    };
  };
in {
  name = "containers-next-wireguard";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    peer0 = { pkgs, ... }: {
      imports = [ base ];
      services.resolved.dnssec = "false";
      systemd.network = {
        netdevs."20-wg0".wireguardPeers = [ {
          wireguardPeerConfig = {
            PublicKey = keypairs.peer1.publicKey;
            AllowedIPs = [ "192.168.23.0/22" "fd42:23:dead:42::/56" ];
            Endpoint = "192.168.1.2:23542";
          };
        } ];
        networks."20-wg0".address = [ "192.168.20.1/22" "fd42:23:dead:42::1/56" ];
      };
    };
    peer1 = { pkgs, ... }: {
      imports = [ base ];
      networking.firewall.allowedUDPPorts = [ 67 68 53 ];

      services.resolved.enable = false;
      systemd.network = {
        netdevs."20-wg0".wireguardPeers = [ {
          wireguardPeerConfig = {
            PublicKey = keypairs.peer0.publicKey;
            AllowedIPs = [ "192.168.23.0/22" "fd42:23:dead:42::/56" ];
            Endpoint = "192.168.1.1:23542";
          };
        } ];
        networks."20-wg0".address = [ "192.168.20.2/22" "fd42:23:dead:42::2/56" ];
      };

      nixos.containers.zones.zone0 = {
        v4.addrPool = [ "192.168.23.1/24" ];
        v6.addrPool = [ "fd42:23:dead:43::/64" ];
      };
      nixos.containers.instances = {
        container0 = {
          activation.strategy = "dynamic";
          zone = "zone0";
        };
      };

      services.kresd = {
        enable = true;
        listenPlain = map (x: "${x}:53") [
          "127.0.0.1" "192.168.20.2"
        ];
        extraConfig = ''
          modules = {
            'hints > iterate',
          }
          hints['peer0.vpn'] = '192.168.20.1'
          hints['peer1.vpn'] = '192.168.20.2'
          hints['peer0.vpn'] = 'fd42:23:dead:42::1'
          hints['peer1.vpn'] = 'fd42:23:dead:42::2'

          ${builtins.readFile ./machined-hostnames-to-dns.lua}

          policy.add(policy.suffix(nspawn_to_dns, policy.todnames({'zone0.peer1.vpn'})))
        '';
      };

      systemd.services."kresd@".environment = let
        lua = pkgs.luajitPackages.lua.withPackages (p: [p.ldbus]);
      in {
        LUA_CPATH = "${lua}/lib/lua/${lua.luaversion}/?.so;";
        LUA_PATH = "${lua}/share/lua/${lua.luaversion}/?.lua;";
      };
    };
  };

  testScript = ''
    start_all()
    peer0.wait_for_unit("multi-user.target")
    peer1.wait_for_unit("multi-user.target")

    def get_container_ip(name, ip_version):
        if ip_version == 4:
            return peer1.succeed(f"machinectl status {name} | grep '192.168.23' | cut -d: -f2 | xargs echo").rstrip()
        else:
            return peer1.succeed(f"machinectl status {name} | grep 'fd42:23' | xargs echo").rstrip()

    with subtest("WireGuard tunnel is up"):
        peer1.wait_until_succeeds("ping -c4 192.168.1.1 >&2")
        peer0.wait_until_succeeds("ping -c4 192.168.1.2 >&2")

        peer1.wait_until_succeeds("ping -c4 192.168.20.1 >&2")
        peer0.wait_until_succeeds("ping -c4 192.168.20.2 >&2")
        peer1.wait_until_succeeds("ping -c4 fd42:23:dead:42::1 >&2")
        peer0.wait_until_succeeds("ping -c4 fd42:23:dead:42::2 >&2")

    with subtest("IPv4 connectivty to container"):
        peer1.succeed("ping -4 -c4 container0 >&2")
        peer0.succeed(f"ping -c4 {get_container_ip('container0', 4)} >&2")

    with subtest("IPv6 connectivity to container"):
        peer1.succeed("ping -6 -c4 container0 >&2")
        peer0.succeed(f"ping -c4 {get_container_ip('container0', 6)} >&2")

    with subtest("DNS"):
        for ip_version in [4, 6]:
            peer1.wait_until_succeeds(f"ping -c4 -{ip_version} >&2 peer0.vpn")
            peer0.wait_until_succeeds(f"ping -c4 -{ip_version} >&2 peer1.vpn")

            peer1.succeed(f"ping -c4 -{ip_version} >&2 container0.zone0.peer1.vpn")
            peer0.succeed(f"ping -c4 -{ip_version} >&2 container0.zone0.peer1.vpn")

        # other records don't give NXDOMAIN
        peer1.succeed("${pkgs.bind.dnsutils}/bin/dig @192.168.20.2 -t MX container0.zone0.peer1.vpn | grep -v NXDOMAIN")

        # tries to recurse it via other nameservers which times out in the sandbox
        peer1.fail("${pkgs.bind.dnsutils}/bin/dig @192.168.20.2 container42.zone0.peer1.vpn")
        peer1.succeed("networkctl down vb-container0")
        peer1.wait_until_fails("ping -c4 container0")
        peer1.succeed("${pkgs.bind.dnsutils}/bin/dig @192.168.20.2 container0.zone0.peer1.vpn | grep NOERROR")

    peer0.shutdown()
    peer1.shutdown()
  '';
})
