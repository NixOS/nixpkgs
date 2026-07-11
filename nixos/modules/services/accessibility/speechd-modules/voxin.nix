{
  lib,
  pkgs,
  mkEnableOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Voxin text to speech output module";

      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debug output.
        '';
        example = true;
      };

      extraConfig = mkExtraConfigOption { };
    };
  };

  # TODO remove if mkPackageOption if Voxin is packaged
  visible = false;
  displayName = "Voxin";
  binary = "sd_voxin";
  confFile = "voxin.conf";
}
