{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.hardware.facetimehd;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.facetimehd.enable = lib.mkEnableOption "the facetimehd kernel module";

  options.hardware.facetimehd.withCalibration = lib.mkOption {
    default = false;
    example = true;
    type = lib.types.bool;
    description = ''
      Whether to include sensor calibration files for facetimehd.
      This makes colors look much better but is experimental, see
      <https://github.com/patjak/facetimehd/wiki/Extracting-the-sensor-calibration-files>
      for details.
    '';
  };

  config = lib.mkIf cfg.enable {

    boot.kernelModules = [ "facetimehd" ];

    boot.blacklistedKernelModules = [ "bdc_pci" ];

    boot.extraModulePackages = [ kernelPackages.facetimehd ];

    hardware.firmware = [
      pkgs.facetimehd-firmware
    ]
    ++ lib.optional cfg.withCalibration pkgs.facetimehd-calibration;

    # unload module during suspend/hibernate as it crashes the whole system
    powerManagement.powerDownCommands = ''
      ${pkgs.kmod}/bin/lsmod | ${pkgs.gnugrep}/bin/grep -q "^facetimehd" && ${pkgs.kmod}/bin/rmmod -f -v facetimehd
    '';

    # and load it back on resume
    powerManagement.resumeCommands = ''
      ${pkgs.kmod}/bin/modprobe -v facetimehd
    '';

  };

}
