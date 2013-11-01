{ config, pkgs, ... }:

{
  imports = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_10;
  boot.vesa = false;
}
