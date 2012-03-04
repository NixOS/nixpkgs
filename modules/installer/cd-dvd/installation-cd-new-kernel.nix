{ config, pkgs, ... }:

{
  require = [ ./installation-cd-graphical.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_2;
  boot.vesa = false;
}
