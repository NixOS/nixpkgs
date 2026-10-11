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
      ];
      default = if zsmallocSupported then "zsmalloc" else "zbud";
      defaultText = literalExpression "if kernel >= 6.3 then \"zsmalloc\" else \"zbud\"";
      description = ''
        Kernel zpool allocator.
        'zsmalloc' is strongly recommended for kernels >= 6.3 as it offers the best density.
        For older kernels, 'zbud' is the fallback.

        Note: 'z3fold' was removed from Linux kernel 6.8 and later.
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
  };

  config = mkIf cfg.enable {
    # 1. Core configuration: kernel parameters for early boot
    boot.kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=${cfg.compressor}"
      "zswap.zpool=${cfg.zpool}"
      "zswap.max_pool_percent=${toString cfg.maxPoolPercent}"
      "zswap.accept_threshold_percent=${toString cfg.acceptThresholdPercent}"
      "zswap.shrinker_enabled=${if cfg.shrinkerEnabled then "1" else "0"}"
    ];

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
      zpool = cfg.zpool;
      max_pool_percent = cfg.maxPoolPercent;
      accept_threshold_percent = cfg.acceptThresholdPercent;
      shrinker_enabled = true;
    };

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
        assertion = config.swapDevices != [ ];
        message = ''
          Zswap requires at least one physical swap device to function as a backing store.

          Try adding the following to your configuration (example):

          swapDevices = [ {
            device = "/var/lib/swapfile";
            size = 16 * 1024; # 16GB
          } ];
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
    ];
  };

  meta.maintainers = with lib.maintainers; [ luochen1990 ];
}
