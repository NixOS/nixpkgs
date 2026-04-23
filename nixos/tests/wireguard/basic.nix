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
  name = "wireguard";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    peer0 = peer {
      ip4 = "192.168.0.1";
      ip6 = "fd00::1";
      extraConfig =
        { lib, pkgs, ... }:
        {
          boot.kernelPackages = lib.mkIf (kernelPackages != null) (kernelPackages pkgs);
          networking.firewall.allowedUDPPorts = [ 23542 ];
          networking.wireguard.interfaces.wg0 = {
            ips = [
              "10.23.42.1/32"
              "fc00::1/128"
            ];
            listenPort = 23542;

            inherit (wg-snakeoil-keys.peer0) privateKey;

            peers = lib.singleton {
              allowedIPs = [
                "10.23.42.2/32"
                "fc00::2/128"
              ];

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
          networking.wireguard.interfaces.wg0 = {
            ips = [
              "10.23.42.2/32"
              "fc00::2/128"
            ];
            listenPort = 23542;
            allowedIPsAsRoutes = false;

            inherit (wg-snakeoil-keys.peer1) privateKey;

            peers = lib.singleton {
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              endpoint = "192.168.0.1:23542";
              persistentKeepalive = 25;

              inherit (wg-snakeoil-keys.peer0) publicKey;
            };

            postSetup =
              let
                ip = lib.getExe' pkgs.iproute2 "ip";
              in
              ''
                ${ip} route replace 10.23.42.1/32 dev wg0
                ${ip} route replace fc00::1/128 dev wg0
              '';
          };
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
}
