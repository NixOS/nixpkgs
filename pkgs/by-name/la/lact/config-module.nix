# Configuration of LACT, as a module that maps the options to the files that
# LACT reads. `pkgs.lact.configFiles` exposes it, so that a system that does not
# use NixOS can also evaluate it.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  format = pkgs.formats.yaml { };
in
{
  options.settings = lib.mkOption {
    default = { };
    type = lib.types.submodule {
      freeformType = format.type;
    };

    description = ''
      Settings for LACT.

      The easiest method of acquiring the settings is to delete
      {file}`/etc/lact/config.yaml`, enter your settings and look
      at the file.

      ::: {.note}
      When `settings` is populated, the config file will be a symbolic link
      and thus LACT daemon will not be able to modify it through the GUI.
      :::
    '';
  };

  config.portable.files."config.yaml" = {
    enable = config.settings != { };
    source = format.generate "lact-config.yaml" config.settings;
  };
}
