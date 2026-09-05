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

      When overriding this, make sure the configuration imports the module
      for the target platform (e.g.
      `"''${modulesPath}/virtualisation/amazon-image.nix"`) and preserves any
      settings the builder default would emit (such as `ec2.efi` or
      `networking.hostId` for ZFS-based EC2 images); otherwise the resulting
      machine may fail to rebuild or boot after `nixos-rebuild`.

      ::: {.warning}
      The configuration file is copied into the world-readable Nix store;
      do not include secrets in it.
      :::
    '';
  };
}
