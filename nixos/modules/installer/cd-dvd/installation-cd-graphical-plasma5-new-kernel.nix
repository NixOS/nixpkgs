{ pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-plasma5.nix ];

  boot.kernel.packages = pkgs.linuxPackages_latest;
}
