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
  options.hardware.dslogic.enable = lib.mkEnableOption "udev rules and software for Dream DreamSourceLab DSLogic devices";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dsview ];
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2a0e", MODE="0666"
    '';
  };

  meta.maintainers = with lib.maintainers; [
    antono
  ];

}
