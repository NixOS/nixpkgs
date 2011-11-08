{ config, pkgs, ... }:

{
  require = [ ./installation-cd-graphical.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_0;
  boot.vesa = false;
}
