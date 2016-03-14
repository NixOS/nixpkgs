{ config, pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-kde.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
