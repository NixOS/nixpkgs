{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.cpu.intel.npu;
in
{
  options = {
    hardware.cpu.intel.npu = {
      enable = lib.mkEnableOption "Intel NPU support";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hardware.graphics.enable;
        message = "Intel NPU requires hardware.graphics.enable to be enabled";
      }
    ];

    hardware.firmware = [ pkgs.intel-npu-driver.firmware ];
    hardware.graphics.extraPackages = [ pkgs.intel-npu-driver ];
    environment.systemPackages = [
      pkgs.intel-npu-driver.validation
      pkgs.level-zero
    ];
  };
}
