{ lib, ... }:

{
  options.virtualisation.configFile = lib.mkOption {
    type = lib.types.nullOr lib.types.path;
    default = null;
    defaultText = lib.literalMD "a default configuration file supplied by the respective image builder";
    description = ''
      A path to a NixOS configuration file which will be placed at
      `/etc/nixos/configuration.nix` in generated virtual machine images and
      used when switching to a new configuration.
      Image builders set a builder-specific default; if set to `null` and no
      builder default applies, no configuration file is installed.
    '';
  };
}
