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
  needsI915 = facterLib.hasIntelCpuModelAtLeast 42 report;

  # Model 61 = Broadwell, minimum for intel-media-driver
  # Pre-Broadwell GPUs should use intel-vaapi-driver instead
  isBroadwellOrNewer = facterLib.hasIntelCpuModelAtLeast 61 report;

  # Model 78 = Skylake, first generation supporting GuC/HuC firmware submission
  hasGuC = facterLib.hasIntelCpuModelAtLeast 78 report;

  # Model 126 = Ice Lake (Gen11), supports HuC firmware loading reliably
  # Gen9-10 (Skylake to Comet Lake) only support GuC submission (enable_guc=2)
  # Gen11+ (Ice Lake+) supports both GuC and HuC (enable_guc=3)
  hasHuC = facterLib.hasIntelCpuModelAtLeast 126 report;

  # Model 140 = Tiger Lake (Xe), supports QSV/VPL and newer OpenCL runtime
  isXeGraphics = facterLib.hasIntelCpuModelAtLeast 140 report;

  # Resolve the effective GuC value based on the option and hardware
  gucValue = if cfg.guc == "auto" then if hasHuC then "3" else "2" else cfg.guc;
in
{
  options.hardware.facter.detected.graphics.intel = {
    enable = lib.mkEnableOption "Enable the Intel Graphics module" // {
      default = hasIntelGpu;
      defaultText = "hardware dependent";
    };

    driver = lib.mkOption {
      type = lib.types.enum [
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

    guc = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "2"
        "3"
        "disable"
      ];
      default = "auto";
      description = ''
        i915 GuC/HuC firmware loading mode:
        - `auto`: selects based on GPU generation (2 for Skylake+, 3 for Ice Lake+)
        - `2`: enable GuC submission only
        - `3`: enable GuC submission and HuC loading
        - `disable`: do not set the kernel parameter
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
          vpl-gpu-rt
          intel-compute-runtime
        ]
        ++ lib.optionals (isBroadwellOrNewer && !isXeGraphics) [
          intel-compute-runtime-legacy1
        ]
      else
        [ intel-vaapi-driver ];

    # Tell libva which driver to use
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME =
        if cfg.driver == "auto" then if isBroadwellOrNewer then "iHD" else "i965" else cfg.driver;
    };

    # Enable GuC/HuC firmware submission for Skylake+ GPUs
    boot.kernelParams = lib.optionals (cfg.guc != "disable" && hasGuC) [
      "i915.enable_guc=${gucValue}"
    ];

    # Intel GPU firmware (GuC/HuC) is part of linux-firmware
    hardware.firmware = [ pkgs.linux-firmware ];
  };
}
