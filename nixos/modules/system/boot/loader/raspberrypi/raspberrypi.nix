{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;

  builderUboot = import ./uboot-builder.nix { inherit pkgs configTxt; inherit (cfg) version; };
  builderGeneric = import ./raspberrypi-builder.nix { inherit pkgs configTxt; };

  builder =
    if cfg.uboot.enable then
      "${builderUboot} -g ${toString cfg.uboot.configurationLimit} -t ${timeoutStr} -c"
    else
      "${builderGeneric} -c";

  blCfg = config.boot.loader;
  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  optional = pkgs.lib.optionalString;

  configTxt =
    pkgs.writeText "config.txt" (''
      # U-Boot used to need this to work, regardless of whether UART is actually used or not.
      # TODO: check when/if this can be removed.
      enable_uart=1

      # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
      # when attempting to show low-voltage or overtemperature warnings.
      avoid_warnings=1
    '' + optional isAarch64 ''
      # Boot in 64-bit mode.
      arm_64bit=1
    '' + (if cfg.uboot.enable then ''
      kernel=u-boot-rpi.bin
    '' else ''
      kernel=kernel.img
      initramfs initrd followkernel
    '') + optional (cfg.firmwareConfig != null) cfg.firmwareConfig);

in

{
  options = {

    boot.loader.raspberryPi = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to create files with the system generations in
          `/boot`.
          `/boot/old` will hold files from old generations.

          ::: {.note}
          These options are deprecated, unsupported, and may not work like expected.
          :::
        '';
      };

      version = mkOption {
        default = 2;
        type = types.enum [ 0 1 2 3 4 ];
        description = lib.mdDoc "";
      };

      uboot = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            Enable using uboot as bootmanager for the raspberry pi.

            ::: {.note}
            These options are deprecated, unsupported, and may not work like expected.
            :::
          '';
        };

        configurationLimit = mkOption {
          default = 20;
          example = 10;
          type = types.int;
          description = lib.mdDoc ''
            Maximum number of configurations in the boot menu.

            ::: {.note}
            These options are deprecated, unsupported, and may not work like expected.
            :::
          '';
        };

      };

      firmwareConfig = mkOption {
        default = null;
        type = types.nullOr types.lines;
        description = lib.mdDoc ''
          Extra options that will be appended to `/boot/config.txt` file.
          For possible values, see: https://www.raspberrypi.com/documentation/computers/config_txt.html

          ::: {.note}
          These options are deprecated, unsupported, and may not work like expected.
          :::
        '';
      };
    };
  };

  config = mkMerge[
    (mkIf cfg.uboot.enable {
      warnings = [
        ''
          The option set for `boot.loader.raspberrypi.uboot` has been recommended against
          for years, and is now formally deprecated.

          It is possible it already did not work like you expected.

          It never worked on the Raspberry Pi 4 family.

          These options will be removed by NixOS 24.11.
        ''
      ];
    })
    (mkIf cfg.enable {
      warnings = [
        ''
          The option set for `boot.loader.raspberrypi` has been recommended against
          for years, and is now formally deprecated.

          It is possible it already did not work like you expected.

          It never worked on the Raspberry Pi 4 family.

          These options will be removed by NixOS 24.11.
        ''
      ];
    })
    (mkIf cfg.enable {
      assertions = singleton {
        assertion = !pkgs.stdenv.hostPlatform.isAarch64 || cfg.version >= 3;
        message = "Only Raspberry Pi >= 3 supports aarch64.";
      };

      system.build.installBootLoader = builder;
      system.boot.loader.id = "raspberrypi";
      system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;
    })
  ];
}
