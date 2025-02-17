{
  config,
  lib,
  pkgs,
  ...
}:
{
  ###### interface
  options = {

    hardware.cpu.intel.enableNpuFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Load the Intel NPU(Neural Processing Unit) firmware for linux intel_vpu module.
      '';
    };

  };

  ###### implementation
  config = lib.mkIf config.hardware.cpu.intel.enableNpuFirmware {
    hardware.firmware = [ pkgs.intel-npu-firmware ];
  };

}
