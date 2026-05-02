{
  lib,
  config,
  pkgs,
  ...
}:
let
  facterLib = import ../lib.nix lib;
  cfg = config.hardware.facter.detected.graphics.intel;
  report = config.hardware.facter.report;

  # Filter graphics cards by Intel vendor ID (0x8086)
  intelGpus = builtins.filter (
    entry:
    let
      vendor = entry.vendor.value or 0;
    in
    vendor == 32902 # 0x8086 - Intel vendor ID
  ) (report.hardware.graphics_card or [ ]);

  hasIntelGpu = builtins.length intelGpus > 0;

  # CPU model thresholds based on Intel CPUID
  # https://en.wikichip.org/wiki/intel/cpuid
  #
  # Model 42 = Sandy Bridge, first generation to use i915 kernel module
  # Older GPUs (Ironlake, GMA) use different modules (i965, gma-*)
  # Xe GPUs (model >= 140, Tiger Lake+) use the xe kernel module instead,
  # so we exclude them here.
  needsI915 = facterLib.hasIntelCpuModelAtLeast 42 report && !isXeGraphics;

  # Model 61 = Broadwell, minimum for intel-media-driver
  # Pre-Broadwell GPUs should use intel-vaapi-driver instead
  isBroadwellOrNewer = facterLib.hasIntelCpuModelAtLeast 61 report;

  # Model 140 = Tiger Lake (Xe), supports QSV/VPL and OpenCL
  # Adds vpl-gpu-rt (oneVPL) and intel-compute-runtime (NEO)
  isXeGraphics = facterLib.hasIntelCpuModelAtLeast 140 report;
in
{
  options.hardware.facter.detected.graphics.intel = {
    enable = lib.mkEnableOption "Enable the Intel Graphics module" // {
      default = hasIntelGpu;
      defaultText = "hardware dependent";
    };

    driver = lib.mkOption {
      type = lib.enum [
        "auto"
        "i965"
        "iHD"
      ];
      default = "auto";
      description = ''
        VA-API driver to use. `auto` selects based on GPU generation
        (iHD for Broadwell+, i965 otherwise). Use this to override
        detection or force a specific driver for debugging.
      '';
    };
  };

  config = lib.mkIf (config.hardware.facter.reportPath != null && cfg.enable) {
    services.xserver.videoDrivers = [ "modesetting" ];

    # Select VA-API driver based on GPU generation:
    # - Broadwell+: intel-media-driver (iHD)
    # - Older: intel-vaapi-driver (i965)
    hardware.graphics.extraPackages =
      with pkgs;
      if isBroadwellOrNewer then
        [ intel-media-driver ]
        ++ lib.optionals isXeGraphics [
          # QSV/VPL runtime for Tiger Lake+
          vpl-gpu-rt
          # OpenCL (NEO) for Xe GPUs
          intel-compute-runtime
        ]
      else
        [ intel-vaapi-driver ];

    # Tell libva which driver to use
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME =
        if cfg.driver == "auto" then if isBroadwellOrNewer then "iHD" else "i965" else cfg.driver;
    };

    # Enable GuC submission and HuC firmware for better performance
    boot.kernelParams = lib.optionals needsI915 [ "i915.enable_guc=3" ];

    # Load Intel firmware blobs (needed for GPU acceleration)
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
