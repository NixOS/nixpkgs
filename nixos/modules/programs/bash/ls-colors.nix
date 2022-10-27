{ config, lib, pkgs, ... }:

with lib;

let
  enable = config.programs.bash.enableLsColors;
in
{
  options = {
    programs.bash.enableLsColors = mkEnableOption (lib.mdDoc "extra colors in directory listings") // {
      default = true;
    };
  };

  config = mkIf enable {
    programs.bash.promptPluginInit = ''
      eval "$(${pkgs.coreutils}/bin/dircolors -b)"
    '';
  };
}
