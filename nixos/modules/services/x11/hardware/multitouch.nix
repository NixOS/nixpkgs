{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.multitouch;
    disabledTapConfig = ''
      Option "MaxTapTime" "0"
      Option "MaxTapMove" "0"
      Option "TapButton1" "0"
      Option "TapButton2" "0"
      Option "TapButton3" "0"
    '';
in {

  options = {

    services.xserver.multitouch = {

      enable = mkOption {
        default = false;
        description = "Whether to enable multitouch touchpad support.";
      };

      invertScroll = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to invert scrolling direction à la OSX Lion";
      };

      ignorePalm = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to ignore touches detected as being the palm (i.e when typing)";
      };

      tapButtons = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable tap buttons.";
      };

      buttonsMap = mkOption {
        type = types.listOf types.int;
        default = [3 2 0];
        example = [1 3 2];
        description = "Remap touchpad buttons.";
        apply = map toString;
      };

      additionalOptions = mkOption {
        type = types.str;
        default = "";
        example = ''
          Option "ScaleDistance" "50"
          Option "RotateDistance" "60"
        '';
        description = ''
          Additional options for mtrack touchpad driver.
        '';
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
          Option "IgnorePalm" "${boolToString cfg.ignorePalm}"
          Option "ClickFinger1" "${builtins.elemAt cfg.buttonsMap 0}"
          Option "ClickFinger2" "${builtins.elemAt cfg.buttonsMap 1}"
          Option "ClickFinger3" "${builtins.elemAt cfg.buttonsMap 2}"
          ${optionalString (!cfg.tapButtons) disabledTapConfig}
          ${optionalString cfg.invertScroll ''
            Option "ScrollUpButton" "5"
            Option "ScrollDownButton" "4"
            Option "ScrollLeftButton" "7"
            Option "ScrollRightButton" "6"
          ''}
          ${cfg.additionalOptions}
        EndSection
      '';

  };

}
