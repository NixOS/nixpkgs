{ config, pkgs, ... }:

{
  imports = [ ./installation-cd-graphical.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
