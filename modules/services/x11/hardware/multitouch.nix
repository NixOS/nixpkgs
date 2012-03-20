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

    };

  };

  config = mkIf config.services.xserver.multitouch.enable {

    services.xserver.modules = [ pkgs.xf86_input_multitouch ];

    services.xserver.config =
      ''
        # Automatically enable the multitouch driver
        Section "InputClass"
          MatchIsTouchpad "on"
          Identifier "Touchpads"
          Driver "mtrack"
        EndSection
      '';

  };

}
