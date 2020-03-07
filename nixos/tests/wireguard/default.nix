let
  wg-snakeoil-keys = import ./snakeoil-keys.nix;
in

import ../make-test-python.nix ({ pkgs, ...} : {
  name = "wireguard";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    peer0 = { lib, ... }: {
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.default.forwarding" = "1";
        "net.ipv4.ip_forward" = "1";
      };

      networking.useDHCP = false;
      networking.interfaces.eth1 = {
        ipv4.addresses = lib.singleton {
          address = "192.168.0.1";
          prefixLength = 24;
        };
        ipv6.addresses = lib.singleton {
          address = "fd00::1";
          prefixLength = 64;
        };
      };

      networking.firewall.allowedUDPPorts = [ 23542 ];
      networking.wireguard.interfaces.wg0 = {
        ips = [ "10.23.42.1/32" "fc00::1/128" ];
        listenPort = 23542;

        inherit (wg-snakeoil-keys.peer0) privateKey;

        peers = lib.singleton {
          allowedIPs = [ "10.23.42.2/32" "fc00::2/128" ];

          inherit (wg-snakeoil-keys.peer1) publicKey;
        };
      };
    };

    peer1 = { pkgs, lib, ... }: {
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.default.forwarding" = "1";
        "net.ipv4.ip_forward" = "1";
      };

      networking.useDHCP = false;
      networking.interfaces.eth1 = {
        ipv4.addresses = lib.singleton {
          address = "192.168.0.2";
          prefixLength = 24;
        };
        ipv6.addresses = lib.singleton {
          address = "fd00::2";
          prefixLength = 64;
        };
      };

      networking.wireguard.interfaces.wg0 = {
        ips = [ "10.23.42.2/32" "fc00::2/128" ];
        listenPort = 23542;
        allowedIPsAsRoutes = false;

        inherit (wg-snakeoil-keys.peer1) privateKey;

        peers = lib.singleton {
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "192.168.0.1:23542";
          persistentKeepalive = 25;

          inherit (wg-snakeoil-keys.peer0) publicKey;
        };

        postSetup = let inherit (pkgs) iproute; in ''
          ${iproute}/bin/ip route replace 10.23.42.1/32 dev wg0
          ${iproute}/bin/ip route replace fc00::1/128 dev wg0
        '';
      };
    };
  };

  testScript = ''
    start_all()

    peer0.wait_for_unit("wireguard-wg0.service")
    peer1.wait_for_unit("wireguard-wg0.service")

    peer1.succeed("ping -c5 fc00::1")
    peer1.succeed("ping -c5 10.23.42.1")
  '';
})
