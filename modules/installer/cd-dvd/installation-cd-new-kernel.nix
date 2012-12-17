{ config, pkgs, ... }:

{
  require = [ ./installation-cd-graphical.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_7;
  boot.vesa = false;
}
