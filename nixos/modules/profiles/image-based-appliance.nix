# This profile sets up a system for image based appliance usage. An appliance is
# installed as an image, cannot be re-built, has no Nix available, and is
# generally not meant for interactive use. Updates to such an appliance are
# handled by updating whole partition images via a tool like systemd-sysupdate.

{ lib, modulesPath, ... }:

{

  # Appliances are always "minimal".
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  # The system cannot be rebuilt.
  nix.enable = false;
  system.switch.enable = false;

  # The system is static.
  users.mutableUsers = false;

  # The system avoids interpreters as much as possible to reduce its attack
  # surface.
  boot.initrd.systemd.enable = lib.mkDefault true;
  networking.useNetworkd = lib.mkDefault true;
}
