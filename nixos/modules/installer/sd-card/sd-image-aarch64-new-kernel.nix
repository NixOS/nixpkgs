{ pkgs, ... }:

{
  imports = [ ./sd-image-aarch64.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
