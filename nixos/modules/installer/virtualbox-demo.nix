{ lib, ... }:

with lib;

{
  imports =
    [ ../virtualisation/virtualbox-image.nix
      ../installer/cd-dvd/channel.nix
      ../profiles/demo.nix
      ../profiles/clone-config.nix
    ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  # Allow mounting of shared folders.
  users.users.demo.extraGroups = [ "vboxsf" ];

  # Add some more video drivers to give X11 a shot at working in
  # VMware and QEMU.
  services.xserver.videoDrivers = mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  powerManagement.enable = false;
  system.stateVersion = mkDefault "18.03";
}
