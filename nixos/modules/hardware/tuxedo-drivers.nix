{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.tuxedo-drivers;
  tuxedo-drivers = config.boot.kernelPackages.tuxedo-drivers;
in
  {
    imports = [
      (mkRenamedOptionModule [ "hardware" "tuxedo-keyboard" "enable" ] [ "hardware" "tuxedo-drivers" "enable" ])
    ];
    options.hardware.tuxedo-drivers = {
      enable = mkEnableOption ''
          Driver pack for tuxedo devices including
          - Driver for Fn-keys
          - SysFS control of brightness/color/mode for most TUXEDO keyboards
          - Hardware I/O driver for TUXEDO Control Center

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

    config = lib.mkIf cfg.enable
    {
      boot.kernelModules = [
        "tuxedo_keyboard"
        "tuxedo_compatibility_check"
        "tuxedo_io"
      ];
      boot.extraModulePackages = [ tuxedo-drivers ];
    };
  }
