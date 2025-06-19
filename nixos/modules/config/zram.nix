{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.zramSwap;
  devices = map (nr: "zram${toString nr}") (lib.range 0 (cfg.swapDevices - 1));

in

{

  imports = [
    (lib.mkRemovedOptionModule [
      "zramSwap"
      "numDevices"
    ] "Using ZRAM devices as general purpose ephemeral block devices is no longer supported")
  ];

  ###### interface

  options = {

    zramSwap = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable in-memory compressed devices and swap space provided by the zram
          kernel module.
          See [
            https://www.kernel.org/doc/Documentation/blockdev/zram.txt
          ](https://www.kernel.org/doc/Documentation/blockdev/zram.txt).
        '';
      };

      swapDevices = lib.mkOption {
        default = 1;
        type = lib.types.int;
        description = ''
          Number of zram devices to be used as swap, recommended is 1.
        '';
      };

      memoryPercent = lib.mkOption {
        default = 50;
        type = lib.types.int;
        description = ''
          Maximum total amount of memory that can be stored in the zram swap devices
          (as a percentage of your total memory). Defaults to 1/2 of your total
          RAM. Run `zramctl` to check how good memory is compressed.
          This doesn't define how much memory will be used by the zram swap devices.
        '';
      };

      memoryMax = lib.mkOption {
        default = null;
        type = with lib.types; nullOr int;
        description = ''
          Maximum total amount of memory (in bytes) that can be stored in the zram
          swap devices.
          This doesn't define how much memory will be used by the zram swap devices.
        '';
      };

      priority = lib.mkOption {
        default = 5;
        type = lib.types.int;
        description = ''
          Priority of the zram swap devices. It should be a number higher than
          the priority of your disk-based swap devices (so that the system will
          fill the zram swap devices before falling back to disk swap).
        '';
      };

      algorithm = lib.mkOption {
        default = "zstd";
        example = "lz4";
        type =
          with lib.types;
          either (enum [
            "842"
            "lzo"
            "lzo-rle"
            "lz4"
            "lz4hc"
            "zstd"
          ]) str;
        description = ''
          Compression algorithm. `lzo` has good compression,
          but is slow. `lz4` has bad compression, but is fast.
          `zstd` is both good compression and fast, but requires newer kernel.
          You can check what other algorithms are supported by your zram device with
          {command}`cat /sys/class/block/zram*/comp_algorithm`
        '';
      };

      writebackDevice = lib.mkOption {
        default = null;
        example = "/dev/zvol/tarta-zoot/swap-writeback";
        type = lib.types.nullOr lib.types.path;
        description = ''
          Write incompressible pages to this device,
          as there's no gain from keeping them in RAM.
        '';
      };

      recommendedSysctlSettings = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable sysctl settings from https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram.
          May set values which aren't ideal for non-zram swap
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.writebackDevice == null || cfg.swapDevices <= 1;
        message = "A single writeback device cannot be shared among multiple zram devices";
      }
    ];

    # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = lib.mkIf cfg.recommendedSysctlSettings {
      # https://github.com/pop-os/default-settings/blob/041cd94158142d6a34d2e684c847ac239a5ba086/etc/sysctl.d/10-pop-default-settings.conf#L2-L3
      # These values are what PopOS always uses, Perhaps they could be moved to `nixos/modules/config/sysctl.nix`
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      # See https://github.com/pop-os/default-settings/blob/041cd94158142d6a34d2e684c847ac239a5ba086/usr/bin/pop-zram-config
      # and https://web.archive.org/web/20231027213550/https://old.reddit.com/r/Fedora/comments/mzun99/new_zram_tuning_benchmarks/
      # These values are what PopOS uses when setting up zram
      # > Number of consecutive pages to read in advance. Higher values increase compression
      # > for zram devices, but at the cost of significantly reduced IOPS and higher latency.
      # > It is highly recommended to use 0 for zstd; and 1 for speedier algorithms.
      "vm.page-cluster" = if cfg.algorithm == "zstd" then 0 else 1;
      "vm.swappiness" = 180;
    };

    services.zram-generator.enable = true;

    services.zram-generator.settings = lib.listToAttrs (
      builtins.map (dev: {
        name = dev;
        value =
          let
            size = "${toString cfg.memoryPercent} / 100 * ram";
          in
          {
            zram-size =
              if cfg.memoryMax != null then "min(${size}, ${toString cfg.memoryMax} / 1024 / 1024)" else size;
            compression-algorithm = cfg.algorithm;
            swap-priority = cfg.priority;
          }
          // lib.optionalAttrs (cfg.writebackDevice != null) {
            writeback-device = cfg.writebackDevice;
          };
      }) devices
    );

  };

}
