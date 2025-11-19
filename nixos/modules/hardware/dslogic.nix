{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.dslogic;
in

{
  options.hardware.dslogic.enable = lib.mkEnableOption "udev rules DreamSourceLab DSLogic devices";

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2a0e", MODE="0666"
    '';
  };

  meta.maintainers = with lib.maintainers; [
    antono
  ];

}
