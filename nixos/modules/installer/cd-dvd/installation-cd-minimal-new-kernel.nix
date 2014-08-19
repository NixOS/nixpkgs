{ config, pkgs, ... }:

{
  imports = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
