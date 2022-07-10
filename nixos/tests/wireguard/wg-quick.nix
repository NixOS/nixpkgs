{ kernelPackages ? null }:

import ../make-test-python.nix ({ pkgs, lib, ... }:
  let
    wg-snakeoil-keys = import ./snakeoil-keys.nix;
    peer = (import ./make-peer.nix) { inherit lib; };
  in
  {
    name = "wg-quick";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ d-xo ];
    };

    nodes = {
      peer0 = peer {
        ip4 = "192.168.0.1";
        ip6 = "fd00::1";
        extraConfig = {
          boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
          networking.firewall.allowedUDPPorts = [ 23542 ];
          networking.wg-quick.interfaces.wg0 = {
            address = [ "10.23.42.1/32" "fc00::1/128" ];
            listenPort = 23542;

            inherit (wg-snakeoil-keys.peer0) privateKey;

            peers = lib.singleton {
              allowedIPs = [ "10.23.42.2/32" "fc00::2/128" ];

              inherit (wg-snakeoil-keys.peer1) publicKey;
            };

            dns = [ "10.23.42.2" "fc00::2" "wg0" ];
          };
        };
      };

      peer1 = peer {
        ip4 = "192.168.0.2";
        ip6 = "fd00::2";
        extraConfig = {
          boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
          networking.useNetworkd = true;
          networking.wg-quick.interfaces.wg0 = {
            address = [ "10.23.42.2/32" "fc00::2/128" ];
            inherit (wg-snakeoil-keys.peer1) privateKey;

            peers = lib.singleton {
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "192.168.0.1:23542";
              persistentKeepalive = 25;

              inherit (wg-snakeoil-keys.peer0) publicKey;
            };

            dns = [ "10.23.42.1" "fc00::1" "wg0" ];
          };
        };
      };
    };

    testScript = ''
      start_all()

      peer0.wait_for_unit("wg-quick-wg0.service")
      peer1.wait_for_unit("wg-quick-wg0.service")

      peer1.succeed("ping -c5 fc00::1")
      peer1.succeed("ping -c5 10.23.42.1")
    '';
  }
)
