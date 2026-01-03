{ lib, config, ... }:
let
  inherit (config.hardware.facter) report;
  cfg = config.hardware.facter.detected.networking.intel;
in
{
  options.hardware.facter.detected.networking.intel = with lib; {
    _2200BG.enable = mkEnableOption "the Facter Intel 2200BG module" // {

      default = lib.any (
        {
          vendor ? { },
          device ? { },
          ...
        }:
        # vendor (0x8086) Intel Corp.
        (vendor.value or 0) == 32902
        && (lib.elem (device.value or 0) [
          4163 # 0x1043
          4175 # 0x104f
          16928 # 0x4220
          16929 # 0x4221
          16931 # 0x4223
          16932 # 0x4224
        ])
      ) (report.hardware.network_controller or [ ]);

      defaultText = "hardware dependent";
    };
    _3945ABG.enable = mkEnableOption "the Facter Intel 3945ABG module" // {

      default = lib.any (
        {
          vendor ? { },
          device ? { },
          ...
        }:
        # vendor (0x8086) Intel Corp.
        (vendor.value or 0) == 32902
        && (lib.elem (device.value or 0) [
          16937 # 0x4229
          16938 # 0x4230
          16930 # 0x4222
          16935 # 0x4227
        ])
      ) (report.hardware.network_controller or [ ]);

      defaultText = "hardware dependent";
    };
  };

  config = lib.mkIf (config.hardware.facter.reportPath != null) {
    networking.enableIntel2200BGFirmware = lib.mkIf cfg._2200BG.enable (lib.mkDefault true);
    hardware.enableRedistributableFirmware = lib.mkIf cfg._3945ABG.enable (lib.mkDefault true);
  };

}
