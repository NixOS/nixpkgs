{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardware.intel.opencl.runtime = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "intel-compute-runtime"
        "intel-ocl"
        "beignet"
      ]
    );
    default = null;
    description = ''
      Select the Intel OpenCL runtime to use. Choose your runtime based on your Intel CPU/GPU generation.

      - `intel-compute-runtime`: Since `Broadwell` 5th gen, open source, runs on GPU
      - `intel-ocl`: Since `Ivy Bridge` 3rd gen, closed source, deprecated, runs on CPU
      - `beignet`:  Since `Ivy Bridge` 3rd gen, open source, deprecated, runs on GPU
    '';
  };

  config = {
    hardware.opengl.extraPackages = lib.mkIf (config.hardware.intel.opencl.runtime != null) [
      pkgs.${config.hardware.intel.opencl.runtime}
    ];
  };
}
