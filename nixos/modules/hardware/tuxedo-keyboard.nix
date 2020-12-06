{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-keyboard;
  tuxedo-keyboard = config.boot.kernelPackages.tuxedo-keyboard;
in
  {
    options.hardware.tuxedo-keyboard = {
      enable = mkEnableOption ''
          Enables the tuxedo-keyboard driver.

          To configure the driver, pass the options to the <option>boot.kernelParams</option> configuration.
          There are several parameters you can change. It's best to check at the source code description which options are supported.
          You can find all the supported parameters at: <link xlink:href="https://github.com/tuxedocomputers/tuxedo-keyboard#kernelparam" />

          In order to use the <literal>custom</literal> lighting with the maximumg brightness and a color of <literal>0xff0a0a</literal> one would put pass <option>boot.kernelParams</option> like this:

          <programlisting>
          boot.kernelParams = [
           "tuxedo_keyboard.mode=0"
           "tuxedo_keyboard.brightness=255"
           "tuxedo_keyboard.color_left=0xff0a0a"
          ];
          </programlisting>
      '';
    };

    config = mkIf cfg.enable
    {
      boot.kernelModules = ["tuxedo_keyboard"];
      boot.extraModulePackages = [ tuxedo-keyboard ];
    };
  }
