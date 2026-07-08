{
  lib,
  pkgs,
  mkPackageOption,
  mkEnableOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Flite text to speech output module";
      package = mkPackageOption pkgs "flite" { };
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

  displayName = "Flite";
  binary = "sd_flite";
  confFile = "flite.conf";
}
