{ config, lib, pkgs, ... }:

let
  enable = config.programs.bash.enableLsColors;
in
{
  options = {
    programs.bash.enableLsColors = lib.mkEnableOption "extra colors in directory listings" // {
      default = true;
    };
  };

  config = lib.mkIf enable {
    programs.bash.promptPluginInit = ''
      eval "$(${pkgs.coreutils}/bin/dircolors -b)"
    '';
  };
}
