{ pkgs, ... }:

{
  imports = [ ./installation-cd-minimal.nix ];

  boot.kernel.packages = pkgs.linuxPackages_latest;
}
