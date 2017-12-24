{ config, lib, pkgs, ... }:

{
  imports = [ ../. ];

  # Use the gummiboot efi boot loader. (From default generated configuration.nix)
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  services.xserver.videoDrivers = [ "intel" ];
}
