# Zswap - Compressed Cache for Swap Pages
#
# Reference documentation:
# - https://docs.kernel.org/admin-guide/mm/zswap.html
# - https://www.kernel.org/doc/html/v6.1/admin-guide/mm/zswap.html
#
# IMPORTANT: When modifying this file, ensure that boot.kernel.sysfs configuration
# remains consistent with kernel parameters configuration. The sysfs settings provide
# runtime management while kernel parameters ensure early-boot availability.

{ config, lib, ... }:

with lib;

let
  cfg = config.boot.zswap;

  # Get the current configured kernel version string
  kernelVersion = config.boot.kernelPackages.kernel.version;

  # Check if kernel supports zsmalloc as zswap backend (>= 6.3)
  zsmallocSupported = versionAtLeast kernelVersion "6.3";

  # Check if kernel supports zbud and z3fold backends (< 6.15)
  zbudSupported = versionOlder kernelVersion "6.15";

  # Check if kernel supports zpool abstraction and configuration (< 6.18)
  zpoolSupported = versionOlder kernelVersion "6.18";
in
{
  options.boot.zswap = {
    enable = mkEnableOption "Zswap (Compressed Cache for Swap Pages)";

    compressor = mkOption {
      type = types.enum [
        "zstd"
        "lz4"
        "lzo"
        "lz4hc"
        "deflate"
        "842"
      ];
      default = "zstd";
      description = ''
        Compression algorithm to use for zswap.

        Available options:
        - 'zstd': Best compression ratio, excellent for Nix builds (default)
        - 'lz4': Fastest compression, lowest latency
        - 'lz4hc': High-compression variant of lz4, slower but better ratio
        - 'lzo': Good balance of speed and compression (kernel default)
        - 'deflate': Higher compression, slower processing
        - '842': Hardware-accelerated compression on supported systems

        Note: The chosen algorithm must be supported by your kernel configuration.
      '';
    };

    zpool = mkOption {
      type = types.enum [
        "zsmalloc"
        "zbud"
        "z3fold"
      ];
      default = if zsmallocSupported then "zsmalloc" else "zbud";
      defaultText = literalExpression "if kernel >= 6.3 then \"zsmalloc\" else \"zbud\"";
      description = ''
        Kernel zpool allocator.
        'zsmalloc' is strongly recommended for kernels >= 6.3 as it offers the best density.
        For older kernels, 'zbud' is the fallback.

        Note: 'zbud' and 'z3fold' were removed from Linux kernel 6.15 and later.
      '';
    };

    maxPoolPercent = mkOption {
      type = types.ints.between 1 100;
      default = 25;
      description = ''
        The maximum percentage of system memory that Zswap can occupy (1-100).

        Higher values provide more compression cache but increase memory pressure.
        Default is 25% (higher than kernel default of 20%) for better Nix build performance.

        Recommended ranges:
        - Desktop systems: 15-25%
        - Low-memory systems: 30-50%
        - Server systems: 10-20%
      '';
    };

    acceptThresholdPercent = mkOption {
      type = types.ints.between 1 100;
      default = 90;
      description = ''
        Threshold percentage at which zswap starts accepting pages again after the pool becomes full (1-100).

        This parameter provides hysteresis to prevent pool oscillation.
        When the pool usage drops below this threshold, zswap starts accepting new pages.
        Default is 90% as recommended by kernel documentation.
      '';
    };

    shrinkerEnabled = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the zswap shrinker to reclaim memory when under pressure.

        When enabled, the shrinker will automatically reclaim compressed pages
        from the zswap pool when the system is under memory pressure, helping
        to prevent out-of-memory situations.

        It is recommended to keep this enabled for most workloads, especially
        on systems with limited memory.
      '';
    };

    dynamicSwap = mkOption {
      type = types.bool;
      default = config.services.swapspace.enable;
      defaultText = literalExpression "config.services.swapspace.enable";
      visible = false;
      description = ''
        Zswap requires a swap device to work properly. By default, the zswap
        module checks for an entry in 'swapDevices' to ensure this condition
        is met. However, some setups add swap devices dynamically, such as with
        GPT partition auto discovery or 'services.swapspace'.

        Set this value to true to assert that a swap device will be added
        dynamically, and bypass the check for a 'swapDevices' entry.
      '';
    };
  };

  config = mkIf cfg.enable {
    # 1. Core configuration: kernel parameters for early boot
    boot.kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=${cfg.compressor}"
      "zswap.max_pool_percent=${toString cfg.maxPoolPercent}"
      "zswap.accept_threshold_percent=${toString cfg.acceptThresholdPercent}"
      "zswap.shrinker_enabled=${if cfg.shrinkerEnabled then "1" else "0"}"
    ]
    ++ optional zpoolSupported "zswap.zpool=${cfg.zpool}";

    # 2. Dependency management: ensure required modules are included in initrd or kernel
    # This ensures Zswap is ready early in the boot process (before swap is mounted)
    boot.initrd.kernelModules = [
      cfg.compressor
      cfg.zpool
    ];

    # 3. Runtime configuration using boot.kernel.sysfs
    # This ensures zswap parameters are properly set and maintained during system rebuilds
    boot.kernel.sysfs.module.zswap.parameters = {
      enabled = true;
      compressor = cfg.compressor;
      max_pool_percent = cfg.maxPoolPercent;
      accept_threshold_percent = cfg.acceptThresholdPercent;
      shrinker_enabled = cfg.shrinkerEnabled;
    }
    // optionalAttrs zpoolSupported { zpool = cfg.zpool; };

    assertions = [
      {
        assertion = !config.zramSwap.enable;
        message = ''
          Conflicting options enabled: 'boot.zswap.enable' and 'zramSwap.enable'.

          You cannot enable Zswap and Zram simultaneously as it leads to double compression
          and inefficient memory management.

          Please disable one of them:
            - To use Zswap (requires a physical swap device): Set 'zramSwap.enable = false'.
            - To use Zram (swap in RAM): Set 'boot.zswap.enable = false'.
        '';
      }
      {
        assertion = config.swapDevices != [ ] || cfg.dynamicSwap;
        message = ''
          Zswap requires at least one physical swap device to function as a backing store.

          Try adding the following to your configuration (example):

          swapDevices = [ {
            device = "/var/lib/swapfile";
            size = 16 * 1024; # 16GB
          } ];

          If swap devices will be added dynamically (eg. by GPT partition auto discovery),
          set 'boot.zswap.dynamicSwap = true' to bypass this check.
        '';
      }
      {
        assertion = (cfg.zpool == "zsmalloc") -> zsmallocSupported;
        message = ''
          Zswap allocator 'zsmalloc' is not supported on kernel version ${kernelVersion}.
          Support for zsmalloc in Zswap was added in Linux 6.3.

          Please use 'zbud' instead: boot.zswap.zpool = "zbud";
        '';
      }
      {
        assertion = (cfg.zpool != "zsmalloc") -> zbudSupported;
        message = ''
          Zswap allocators 'zbud' and 'z3fold' are not supported on kernel version ${kernelVersion}.
          Support for zbud and z3fold in Zswap was removed in Linux 6.15 in favor of zsmalloc.

          Please use 'zsmalloc' instead: boot.zswap.zpool = "zsmalloc";
        '';
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [ luochen1990 ];
}
