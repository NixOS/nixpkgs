{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;
  blCfg = config.boot.loader;


  firmwareBuilder = pkgs.callPackage ./firmware-builder.nix {
    inherit (cfg) version;
    ubootEnabled = cfg.uboot.enable;
  };
  extlinuxConfBuilder = pkgs.callPackage ../generic-extlinux-compatible/extlinux-conf-builder.nix { };
  raspberryPiBuilder = pkgs.callPackage ./raspberrypi-builder.nix { };

  builder = pkgs.writeScript "install-raspberrypi-bootloader.sh" (''
    #!${pkgs.runtimeShell}
    '${firmwareBuilder}' -d '${cfg.firmwareDir}' -c '${configTxt}'
  '' + (if cfg.uboot.enable then ''
    '${extlinuxConfBuilder}' -g '${toString cfg.uboot.configurationLimit}' -t '${timeoutStr}' -c "$@"
  '' else ''
    '${raspberryPiBuilder}' -d '${cfg.firmwareDir}' -c "$@"
  ''));

  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  configTxt = pkgs.writeText "config.txt" cfg.firmwareConfig;
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
        '';
      };

      version = mkOption {
        default = 2;
        type = types.enum [ 0 1 2 3 4 ];
        description = lib.mdDoc "";
      };

      uboot = {
        enable = mkEnableOption "U-Boot as the bootloader for the Raspberry Pi";

        configurationLimit = mkOption {
          default = 20;
          example = 10;
          type = types.int;
          description = lib.mdDoc ''
            Maximum number of configurations in the boot menu.
          '';
        };
      };

      firmwareConfig = mkOption {
        type = types.lines;
        description = lib.mdDoc ''
          Extra options that will be appended to `/boot/config.txt` file.
          For possible values, see: https://www.raspberrypi.com/documentation/computers/config_txt.html
        '';
      };

      firmwareDir = mkOption {
        default = "/boot";
        type = types.path;
        description = lib.mdDoc ''
          Mount point of the firmware partition.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = !pkgs.stdenv.hostPlatform.isAarch64 || cfg.version >= 3;
      message = "Only Raspberry Pi >= 3 supports aarch64.";
    };

    boot.loader.raspberryPi.firmwareConfig = mkBefore (''
      # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
      # when attempting to show low-voltage or overtemperature warnings.
      avoid_warnings=1
    '' + optionalString pkgs.stdenv.hostPlatform.isAarch64 ''
      # Boot in 64-bit mode.
      arm_64bit=1
    '' + (if cfg.uboot.enable then ''
      kernel=u-boot-rpi.bin
    '' else ''
      kernel=kernel.img
      initramfs initrd followkernel
    ''));

    system.build.installBootLoader = builder;
    system.boot.loader.id = "raspberrypi";
    system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;
  };
}
