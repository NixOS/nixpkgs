{ config, pkgs, ... }:

{
  require = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_7;
  boot.vesa = false;
}
