{ config, lib, pkgs, ... }:

let

  cfg = config.zramSwap;
  devices = map (nr: "zram${toString nr}") (lib.range 0 (cfg.swapDevices - 1));

in

{

  imports = [
    (lib.mkRemovedOptionModule [ "zramSwap" "numDevices" ] "Using ZRAM devices as general purpose ephemeral block devices is no longer supported")
  ];

  ###### interface

  options = {

    zramSwap = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Number of zram devices to be used as swap, recommended is 1.
        '';
      };

      memoryPercent = lib.mkOption {
        default = 50;
        type = lib.types.int;
        description = lib.mdDoc ''
          Maximum total amount of memory that can be stored in the zram swap devices
          (as a percentage of your total memory). Defaults to 1/2 of your total
          RAM. Run `zramctl` to check how good memory is compressed.
          This doesn't define how much memory will be used by the zram swap devices.
        '';
      };

      memoryMax = lib.mkOption {
        default = null;
        type = with lib.types; nullOr int;
        description = lib.mdDoc ''
          Maximum total amount of memory (in bytes) that can be stored in the zram
          swap devices.
          This doesn't define how much memory will be used by the zram swap devices.
        '';
      };

      priority = lib.mkOption {
        default = 5;
        type = lib.types.int;
        description = lib.mdDoc ''
          Priority of the zram swap devices. It should be a number higher than
          the priority of your disk-based swap devices (so that the system will
          fill the zram swap devices before falling back to disk swap).
        '';
      };

      algorithm = lib.mkOption {
        default = "zstd";
        example = "lz4";
        type = with lib.types; either (enum [ "lzo" "lz4" "zstd" ]) str;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Write incompressible pages to this device,
          as there's no gain from keeping them in RAM.
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

    services.zram-generator.enable = true;

    services.zram-generator.settings = lib.listToAttrs
      (builtins.map
        (dev: {
          name = dev;
          value =
            let
              size = "${toString cfg.memoryPercent} / 100 * ram";
            in
            {
              zram-size = if cfg.memoryMax != null then "min(${size}, ${toString cfg.memoryMax} / 1024 / 1024)" else size;
              compression-algorithm = cfg.algorithm;
              swap-priority = cfg.priority;
            } // lib.optionalAttrs (cfg.writebackDevice != null) {
              writeback-device = cfg.writebackDevice;
            };
        })
        devices);

  };

}
