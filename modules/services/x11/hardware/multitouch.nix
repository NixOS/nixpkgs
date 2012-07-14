{ config, pkgs, ... }:

with pkgs.lib;

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

    };

  };

  config = mkIf config.services.xserver.multitouch.enable {

    services.xserver.modules = [ pkgs.xf86_input_mtrack ];

    services.xserver.config =
      ''
        # Automatically enable the multitouch driver
        Section "InputClass"
          MatchIsTouchpad "on"
          Identifier "Touchpads"
          Driver "mtrack"
          ${optionalString config.services.xserver.multitouch.invertScroll ''
            Option "ScrollUpButton" "5"
            Option "ScrollDownButton" "4"
          ''}
        EndSection
      '';

  };

}
