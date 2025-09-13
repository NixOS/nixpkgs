{
  lib,
  kernelPackages ? null,
  ...
}:
let
  wg-snakeoil-keys = import ./snakeoil-keys.nix;
  peer = import ./make-peer.nix;
in
{
  name = "wireguard-networkd";
  meta.maintainers = with lib.maintainers; [ majiir ];

  nodes = {
    peer0 = peer {
      ip4 = "192.168.0.1";
      ip6 = "fd00::1";
      extraConfig =
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = lib.mkIf (kernelPackages != null) (kernelPackages pkgs);
          networking.firewall.allowedUDPPorts = [ 23542 ];
          networking.wireguard.useNetworkd = true;
          networking.wireguard.interfaces.wg0 = {
            ips = [
              "10.23.42.1/32"
              "fc00::1/128"
            ];
            listenPort = 23542;

            # !!! Don't do this with real keys. The /nix store is world-readable!
            privateKeyFile = toString (pkgs.writeText "privateKey" wg-snakeoil-keys.peer0.privateKey);

            peers = lib.singleton {
              allowedIPs = [
                "10.23.42.2/32"
                "fc00::2/128"
              ];

              # !!! Don't do this with real keys. The /nix store is world-readable!
              presharedKeyFile = toString (pkgs.writeText "presharedKey" wg-snakeoil-keys.presharedKey);

              inherit (wg-snakeoil-keys.peer1) publicKey;
            };
          };
        };
    };

    peer1 = peer {
      ip4 = "192.168.0.2";
      ip6 = "fd00::2";
      extraConfig =
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = lib.mkIf (kernelPackages != null) (kernelPackages pkgs);
          networking.wireguard.useNetworkd = true;
          networking.wireguard.interfaces.wg0 = {
            ips = [
              "10.23.42.2/32"
              "fc00::2/128"
            ];
            listenPort = 23542;

            # !!! Don't do this with real keys. The /nix store is world-readable!
            privateKeyFile = toString (pkgs.writeText "privateKey" wg-snakeoil-keys.peer1.privateKey);

            peers = lib.singleton {
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              endpoint = "192.168.0.1:23542";
              persistentKeepalive = 25;

              # !!! Don't do this with real keys. The /nix store is world-readable!
              presharedKeyFile = toString (pkgs.writeText "presharedKey" wg-snakeoil-keys.presharedKey);

              inherit (wg-snakeoil-keys.peer0) publicKey;
            };
          };
        };
    };
  };

  testScript = ''
    start_all()

    peer0.systemctl("start network-online.target")
    peer0.wait_for_unit("network-online.target")

    peer1.systemctl("start network-online.target")
    peer1.wait_for_unit("network-online.target")

    peer1.succeed("ping -c5 fc00::1")
    peer1.succeed("ping -c5 10.23.42.1")

    with subtest("Has PSK set"):
      peer0.succeed("wg | grep 'preshared key'")
      peer1.succeed("wg | grep 'preshared key'")
  '';
}
