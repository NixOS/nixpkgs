{ lib, ... }:

{
  options.virtualisation.configFile = lib.mkOption {
    type = lib.types.path;
    description = ''
      A path to a NixOS configuration file which will be placed at
      `/etc/nixos/configuration.nix` in generated virtual machine images and
      used when switching to a new configuration.
    '';
  };
}
