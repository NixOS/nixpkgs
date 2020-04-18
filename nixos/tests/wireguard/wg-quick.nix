import ../make-test-python.nix ({ pkgs, lib, ... }:
  let
    wg-snakeoil-keys = import ./snakeoil-keys.nix;
    peer = (import ./make-peer.nix) { inherit lib; };
  in
  {
    name = "wg-quick";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ xwvvvvwx ];
    };

    nodes = {
      peer0 = peer {
        ip4 = "192.168.0.1";
        ip6 = "fd00::1";
        extraConfig = {
          networking.firewall.allowedUDPPorts = [ 23542 ];
          networking.wg-quick.interfaces.wg0 = {
            address = [ "10.23.42.1/32" "fc00::1/128" ];
            listenPort = 23542;

            inherit (wg-snakeoil-keys.peer0) privateKey;

            peers = lib.singleton {
              allowedIPs = [ "10.23.42.2/32" "fc00::2/128" ];

              inherit (wg-snakeoil-keys.peer1) publicKey;
            };
          };
        };
      };

      peer1 = peer {
        ip4 = "192.168.0.2";
        ip6 = "fd00::2";
        extraConfig = {
          networking.wg-quick.interfaces.wg0 = {
            address = [ "10.23.42.2/32" "fc00::2/128" ];
            inherit (wg-snakeoil-keys.peer1) privateKey;

            peers = lib.singleton {
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "192.168.0.1:23542";
              persistentKeepalive = 25;

              inherit (wg-snakeoil-keys.peer0) publicKey;
            };
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
