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
      enable = mkEnableOption "Cicero text to speech output module";
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

  # TODO Delete if Cicero gets packaged in Nixpkgs
  visible = false;
  displayName = "Cicero";
  binary = "sd_cicero";
  confFile = "cicero.conf";
}
