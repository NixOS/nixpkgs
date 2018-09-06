{ config, lib, ... }:

with lib;
{
  options = {
    xdg.autostart.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html">XDG Autostart specification</link>.
      '';
    };
  };

  config = mkIf config.xdg.autostart.enable {
    environment.pathsToLink = [ 
      "/etc/xdg/autostart"
    ];
  };

}
