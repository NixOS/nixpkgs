{ pkgs, ... }:

{
  imports = [ ./sd-image-aarch64.nix ];

  boot.kernel.packages = pkgs.linuxPackages_latest;
}
