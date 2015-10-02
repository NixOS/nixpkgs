{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ ../virtualisation/nova-image.nix
      ../installer/cd-dvd/channel.nix
      ../profiles/clone-config.nix
    ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  boot.loader.grub.gfxmodeBios = "text";
  boot.kernelParams = [ "nosetmode" ];
  boot.blacklistedKernelModules = ["bochs_drm"];  

  boot.supportedFilesystems = [ "xfs" ];
  boot.initrd.supportedFilesystems = [ "xfs" ];
  environment.noXlibs = true;

}
