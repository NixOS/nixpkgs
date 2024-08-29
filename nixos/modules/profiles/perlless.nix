{ lib, pkgs, ... }:

{

  # switch-to-configuration-ng reimplements switch-to-configuration, but
  # without perl.
  system.switch = lib.mkDefault {
    enable = false;
    enableNg = true;
  };

  # Remove perl from activation
  boot.initrd.systemd.enable = lib.mkDefault true;
  system.etc.overlay.enable = lib.mkDefault true;
  systemd.sysusers.enable = lib.mkDefault true;

  # Random perl remnants
  system.disableInstallerTools = lib.mkDefault true;
  programs.less.lessopen = lib.mkDefault null;
  programs.command-not-found.enable = lib.mkDefault false;
  boot.enableContainers = lib.mkDefault false;
  boot.loader.grub.enable = lib.mkDefault false;
  environment.defaultPackages = lib.mkDefault [ ];
  documentation.info.enable = lib.mkDefault false;

  # Check that the system does not contain a Nix store path that contains the
  # string "perl".
  system.forbiddenDependenciesRegexes = ["perl"];

  # Re-add nixos-rebuild to the systemPackages that was removed by the
  # `system.disableInstallerTools` option.
  environment.systemPackages = [pkgs.nixos-rebuild];

}
