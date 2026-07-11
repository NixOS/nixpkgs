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
      enable = mkEnableOption "Baratinoo text to speech output module";
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

  # TODO Delete if Baratinoo gets packaged in Nixpkgs
  visible = false;
  displayName = "Baratinoo";
  binary = "sd_baratinoo";
  confFile = "baratinoo.conf";

}
