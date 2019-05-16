{ config, lib, ... }:

with lib;
{
  options = {
    xdg.icons.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html">XDG Icon Theme specification</link>.
      '';
    };
  };

  config = mkIf config.xdg.icons.enable {
    environment.pathsToLink = [ 
      "/share/icons" 
      "/share/pixmaps" 
    ];
    
    environment.profileRelativeEnvVars = {
      XCURSOR_PATH = [ "/share/icons" ];
    };
  };

}
