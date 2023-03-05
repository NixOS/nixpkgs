{ config, lib, pkgs, ... }:
{
  options.hardware.intel.opencl.enable = lib.mkEnableOption (lib.mdDoc
    "intel opencl runtime (Install icd for Intel GPUs)"
  );

  config = lib.mkIf config.hardware.intel.opencl.enable {
    hardware.opengl.extraPackages = with pkgs; [
      intel-compute-runtime
      intel-ocl
    ];
  };
}
