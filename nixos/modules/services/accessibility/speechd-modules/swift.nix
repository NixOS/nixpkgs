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
      enable = mkEnableOption "Swift text to speech output module";

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

  # TODO delete if SwiftTTS is packaged in Nixpkgs.
  visible = false;
  displayName = "SwiftTTS";
  confFile = "swift-generic.conf";
}
