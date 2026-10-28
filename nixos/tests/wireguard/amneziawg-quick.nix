{
  lib,
  kernelPackages ? null,
  nftables ? false,
  ...
}:
let
  wg-snakeoil-keys = import ./snakeoil-keys.nix;
  peer = import ./make-peer.nix;
  commonConfig =
    { pkgs, ... }:
    {
      boot.kernelPackages = lib.mkIf (kernelPackages != null) (kernelPackages pkgs);
      networking.nftables.enable = nftables;
      # Make sure iptables doesn't work with nftables enabled
      boot.blacklistedKernelModules = lib.mkIf nftables [ "nft_compat" ];
    };
  extraOptions = {
    Jc = 5;
    Jmin = 10;
    Jmax = 42;
    S1 = 60;
    S2 = 90;
  };
in
{
  name = "amneziawg-quick";
  meta.maintainers = with lib.maintainers; [
    averyanalex
    azahi
  ];

  nodes = {
    peer0 = peer {
      ip4 = "192.168.0.1";
      ip6 = "fd00::1";
      extraConfig = {
        imports = [ commonConfig ];

        networking.firewall.allowedUDPPorts = [ 23542 ];
        networking.wg-quick.interfaces.wg0 = {
          type = "amneziawg";

          address = [
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

          dns = [
            "10.23.42.2"
            "fc00::2"
            "wg0"
          ];

          inherit extraOptions;
        };
      };
    };

    peer1 = peer {
      ip4 = "192.168.0.2";
      ip6 = "fd00::2";
      extraConfig = {
        imports = [ commonConfig ];

        networking.useNetworkd = true;
        networking.wg-quick.interfaces.wg0 = {
          type = "amneziawg";

          address = [
            "10.23.42.2/32"
            "fc00::2/128"
          ];
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

          dns = [
            "10.23.42.1"
            "fc00::1"
            "wg0"
          ];

          inherit extraOptions;
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
