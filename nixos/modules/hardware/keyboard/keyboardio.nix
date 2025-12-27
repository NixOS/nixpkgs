{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.keyboard.keyboardio;
  inherit (lib) mkEnableOption mkIf mdDoc;

in
{
  options.hardware.keyboard.keyboardio = {
    enable = mkEnableOption ''
      udev rules for keyboards from Keyboardio like the Model 100 or the Atreus.
      You need it when you want to flash a new configuration on the keyboard
      or use their live training in the browser.
      You may want to install the chrysalis package.
    '';
  };

  config = mkIf cfg.enable { services.udev.packages = [ pkgs.keyboardio-udev-rules ]; };
}
