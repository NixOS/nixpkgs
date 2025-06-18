{ pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-plasma5.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
