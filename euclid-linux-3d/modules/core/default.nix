{ config, pkgs, lib, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "euclid";
  system.stateVersion = "24.05"; # adjust if needed
}
