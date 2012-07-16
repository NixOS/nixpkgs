{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.xserver.multitouch; in

{

  options = {

    services.xserver.multitouch = {

      enable = mkOption {
        default = false;
        example = true;
        description = "Whether to enable multitouch touchpad support.";
      };

      invertScroll = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Whether to invert scrolling direction à la OSX Lion";
      };

      ignorePalm = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Whether to ignore touches detected as being the palm (i.e when typing)";
      };

    };

  };

  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xf86_input_mtrack ];

    services.xserver.config =
      ''
        # Automatically enable the multitouch driver
        Section "InputClass"
          MatchIsTouchpad "on"
          Identifier "Touchpads"
          Driver "mtrack"
          Option "IgnorePalm" "${if cfg.ignorePalm then "true" else "false"}"
          ${optionalString cfg.invertScroll ''
            Option "ScrollUpButton" "5"
            Option "ScrollDownButton" "4"
            Option "ScrollLeftButton" "7"
            Option "ScrollRightButton" "6"
          ''}
        EndSection
      '';

  };

}
