{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../.
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}
