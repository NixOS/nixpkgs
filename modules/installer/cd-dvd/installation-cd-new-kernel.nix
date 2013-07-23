{ config, pkgs, ... }:

{
  require = [ ./installation-cd-graphical.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_10;
  boot.vesa = false;
}
