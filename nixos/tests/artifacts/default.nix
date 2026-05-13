{ pkgs ? import <nixpkgs> {}, ... }:

{
  dummy-basic = pkgs.callPackage ./dummy-basic.nix {};
  dummy-permissions = pkgs.callPackage ./dummy-permissions.nix {};
  dummy-ordering = pkgs.callPackage ./dummy-ordering.nix {};
  store-leak-rejected = pkgs.callPackage ./store-leak-rejected.nix {};
  systemd-creds-basic = pkgs.callPackage ./systemd-creds-basic.nix {};
  regression-rebuild = pkgs.callPackage ./regression-rebuild.nix {};
}
