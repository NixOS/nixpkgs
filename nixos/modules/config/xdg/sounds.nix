{ config, lib, ... }:

with lib;
{
  options = {
    xdg.sounds.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        <link xlink:href="https://www.freedesktop.org/wiki/Specifications/sound-theme-spec/">XDG Sound Theme specification</link>.
      '';
    };
  };

  config = mkIf config.xdg.sounds.enable {
    environment.pathsToLink = [
      "/share/sounds"
    ];
  };

}
