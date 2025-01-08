{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hardware.coral;
in

{
  options.hardware.coral = {
    usb.enable = lib.mkEnableOption "Coral USB support";
    pcie.enable = lib.mkEnableOption "Coral PCIe support";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.usb.enable || cfg.pcie.enable) {
      users.groups.coral = { };
    })
    (lib.mkIf cfg.usb.enable {
      services.udev.packages = with pkgs; [ libedgetpu ];
    })
    (lib.mkIf cfg.pcie.enable {
      boot.extraModulePackages = with config.boot.kernelPackages; [ gasket ];
      services.udev.extraRules = ''
        SUBSYSTEM=="apex",MODE="0660",GROUP="coral"
      '';
    })
  ];
}
