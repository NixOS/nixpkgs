# Tests in: ../../../../tests/modular-service-etc/test.nix
# This file is a function that returns a module.
pkgs:
{
  lib,
  name,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether this configuration file should be generated.
        This option allows specific configuration files to be disabled.
      '';
    };

    name = mkOption {
      type = types.str;
      description = ''
        Name of the configuration file (relative to the service's configuration directory). Defaults to the attribute name.
      '';
    };

    path = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        The actual path where this configuration file will be available.
        This is determined by the service manager implementation.

        On NixOS it is an absolute path.
        Other service managers may provide a relative path, in order to be unprivileged and/or relocatable.
      '';
    };

    text = mkOption {
      default = null;
      type = types.nullOr types.lines;
      description = "Text content of the configuration file.";
    };

    source = mkOption {
      type = types.path;
      description = "Path of the source file.";
    };
  };

  config = {
    name = lib.mkDefault name;
    source = lib.mkIf (config.text != null) (
      let
        name' = "service-configdata-" + lib.replaceStrings [ "/" ] [ "-" ] name;
      in
      lib.mkDerivedConfig options.text (pkgs.writeText name')
    );
  };
}
