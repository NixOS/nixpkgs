# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

{
  imports = [ ./sd-image-aarch64.nix ];
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
}
