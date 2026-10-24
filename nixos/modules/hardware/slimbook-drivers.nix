{
  config,
  lib,
  ...
}:

let
  cfg = config.hardware.slimbook-drivers;
  slimbook_qc71_laptop = config.boot.kernelPackages.slimbook_qc71_laptop;
in
{
  options.hardware.slimbook-drivers = {
    enable = lib.mkEnableOption "Linux kernel platform driver for QC71 based Slimbook laptops";
    enableBatteryChargeLimit = lib.mkEnableOption "battery charge limit for QC71 based Slimbook laptops";
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ slimbook_qc71_laptop ];
    boot.kernelModules = [ "qc71_laptop" ];
    boot.extraModprobeConfig = lib.mkIf cfg.enableBatteryChargeLimit ''
      options qc71_laptop show_charge_limit=true
    '';
  };
}
