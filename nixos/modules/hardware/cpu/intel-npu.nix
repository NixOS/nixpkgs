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
    hardware.firmware = [ pkgs.intel-npu-firmware ];
    environment.systemPackages = [
      pkgs.intel-npu-driver
      pkgs.level-zero
    ];
  };
}
