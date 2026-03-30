{
  config,
  lib,
  pkgs,
  ...
}:

let
  enable = config.programs.bash.enableLsColors;
in
{
  options = {
    programs.bash.enableLsColors = lib.mkEnableOption "extra colors in directory listings" // {
      default = true;
    };
    programs.bash.lsColorsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "\${pkgs.dircolors-solarized}/ansi-dark";
      description = "Alternative colorscheme for ls colors";
    };
  };

  config = lib.mkIf enable {
    programs.bash.promptPluginInit = ''
      eval "$(${pkgs.coreutils}/bin/dircolors -b ${
        lib.optionalString (config.programs.bash.lsColorsFile != null) config.programs.bash.lsColorsFile
      })"
    '';
  };
}
