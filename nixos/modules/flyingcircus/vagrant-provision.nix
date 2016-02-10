{ config, lib, pkgs, ... }:
with config;
{

  # *Always* build the DEV nix. It's quite confusing to have different
  # configurations all the time.
  environment.shellInit =
  ''
    export NIX_PATH="nixpkgs=/root/nixpkgs:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  '';

  flyingcircus.enc = {
    parameters = {
      location = "vagrant";
      interfaces = {
        fe = {
          bridged = false;
          mac = "10:00:00:02:12:25";
          networks = {
            "195.62.125.0/25" = [];
            "192.168.12.0/24" = ["192.168.12.146" "192.168.12.147"];
            "fd:248:101:62::/64" = [];
          };
          gateways = {
           "192.168.12.0/24" = "192.168.12.1";
           "fd:248:101:62::/64" = "fd:248:101:62::1";
          };
        };
        srv = {
          bridged = false;
          mac = "10:00:00:03:12:25";
          networks = {
            "192.168.13.0/24" = ["192.168.13.146"];
            "195.62.125.128/25" = [];
            "195.62.126.128/25" = [];
            "fd:248:101:63::/64" = ["fd:248:101:63::110a"];
          };
          gateways = {
            "fd:248:101:63::/64" = "fd:248:101:63::1";
            "192.168.13.0/24" = "192.168.13.1";
          };
        };
      };
    };
  };
}
