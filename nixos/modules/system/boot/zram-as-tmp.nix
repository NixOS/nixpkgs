{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.boot.tmp;
in
{
  options = {
    boot.tmp = {
      useZram = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          Whether to mount a zram device on {file}`/tmp` during boot.

          ::: {.note}
          Large Nix builds can fail if the mounted zram device is not large enough.
          In such a case either increase the zramSettings.zram-size or disable this option.
          :::
        '';
      };

      zramSettings = {
        zram-size = lib.mkOption {
          type = lib.types.str;
          default = "ram * 0.5";
          example = "min(ram / 2, 4096)";
          description = ''
            The size of the zram device, as a function of MemTotal, both in MB.
            For example, if the machine has 1 GiB, and zram-size=ram/4,
            then the zram device will have 256 MiB.
            Fractions in the range 0.1–0.5 are recommended

            See: <https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example>
          '';
        };

        compression-algorithm = lib.mkOption {
          type = lib.types.str;
          default = "zstd";
          example = "lzo-rle";
          description = ''
            The compression algorithm to use for the zram device.

            See: <https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example>
          '';
        };

        fs-type = lib.mkOption {
          type = lib.types.str;
          default = "ext4";
          example = "ext2";
          description = ''
            The file system to put on the device.

            See: <https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example>
          '';
        };

        options = lib.mkOption {
          type = lib.types.str;
          default = "X-mount.mode=1777,discard";
          description = ''
            By default, file systems and swap areas are trimmed on-the-go
            by setting "discard".
            Setting this to the empty string clears the option.

            See: <https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example>
          '';
        };
      };
    };
  };

  config = lib.mkIf (cfg.useZram) {
    assertions = [
      {
        assertion = !cfg.useTmpfs;
        message = "boot.tmp.useTmpfs is unnecessary if useZram=true";
      }
    ];

    services.zram-generator.enable = true;
    services.zram-generator.settings =
      let
        cfgz = cfg.zramSettings;
      in
      {
        "zram${toString (if config.zramSwap.enable then config.zramSwap.swapDevices else 0)}" = {
          mount-point = "/tmp";
          zram-size = cfgz.zram-size;
          compression-algorithm = cfgz.compression-algorithm;
          options = cfgz.options;
          fs-type = cfgz.fs-type;
        };
      };
    systemd.services."systemd-zram-setup@".path = [ pkgs.util-linux ] ++ config.system.fsPackages;

  };
}
