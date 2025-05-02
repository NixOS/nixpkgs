{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-keyboard;
  tuxedo-keyboard = config.boot.kernelPackages.tuxedo-keyboard;
in
  {
    options.hardware.tuxedo-keyboard = {
      enable = mkEnableOption ''
          the tuxedo-keyboard driver.

          To configure the driver, pass the options to the {option}`boot.kernelParams` configuration.
          There are several parameters you can change. It's best to check at the source code description which options are supported.
          You can find all the supported parameters at: <https://github.com/tuxedocomputers/tuxedo-keyboard#kernelparam>

          In order to use the `custom` lighting with the maximumg brightness and a color of `0xff0a0a` one would put pass {option}`boot.kernelParams` like this:

          ```
          boot.kernelParams = [
           "tuxedo_keyboard.mode=0"
           "tuxedo_keyboard.brightness=255"
           "tuxedo_keyboard.color_left=0xff0a0a"
          ];
          ```
      '';
    };

    config = mkIf cfg.enable
    {
      boot.kernelModules = ["tuxedo_keyboard"];
      boot.extraModulePackages = [ tuxedo-keyboard ];
    };
  }
