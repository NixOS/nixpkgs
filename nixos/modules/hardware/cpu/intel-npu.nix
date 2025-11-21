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
    environment.systemPackages = [
      pkgs.intel-npu-driver.validation
      pkgs.level-zero
    ];

    hardware = {
      firmware = [ pkgs.intel-npu-driver.firmware ];
      graphics = {
        enable = true;
        extraPackages = [ pkgs.intel-npu-driver ];
      };
    };
  };
}
