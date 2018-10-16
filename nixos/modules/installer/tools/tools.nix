# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, ... }:

with lib;

let
  nixos-build-vms = pkgs.nixos-build-vms;
  nixos-enter = pkgs.nixos-enter;
  nixos-generate-config = pkgs.nixos-generate-config.override { inherit (config.system.nixos) release; };
  nixos-install = pkgs.nixos-install.override { nix = config.nix.package; };
  nixos-option = pkgs.nixos-option;
  nixos-rebuild = pkgs.nixos-rebuild.override { nix = config.nix.package; };
  nixos-version = pkgs.nixos-version.override { inherit (config.system.nixos) version codeName revision; };
in

{
  config = {
    environment.systemPackages = [
      nixos-build-vms
      nixos-enter
      nixos-generate-config
      nixos-install
      nixos-option
      nixos-rebuild
      nixos-version
    ];

    system.build = {
      inherit
        nixos-enter
        nixos-generate-config
        nixos-install
        nixos-option
        nixos-rebuild
        ;
    };
  };
}
