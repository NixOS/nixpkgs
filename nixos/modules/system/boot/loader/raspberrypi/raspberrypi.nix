{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;

  inherit (pkgs.stdenv.hostPlatform) platform;

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
  optional = pkgs.stdenv.lib.optionalString;

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
        description = ''
          Whether to create files with the system generations in
          <literal>/boot</literal>.
          <literal>/boot/old</literal> will hold files from old generations.
        '';
      };

      version = mkOption {
        default = 2;
        type = types.enum [ 0 1 2 3 ];
        description = ''
        '';
      };

      uboot = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Enable using uboot as bootmanager for the raspberry pi.
          '';
        };

        configurationLimit = mkOption {
          default = 20;
          example = 10;
          type = types.int;
          description = ''
            Maximum number of configurations in the boot menu.
          '';
        };

      };

      firmwareConfig = mkOption {
        default = null;
        type = types.nullOr types.string;
        description = ''
          Extra options that will be appended to <literal>/boot/config.txt</literal> file.
          For possible values, see: https://www.raspberrypi.org/documentation/configuration/config-txt/
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = !pkgs.stdenv.hostPlatform.isAarch64 || cfg.version == 3;
      message = "Only Raspberry Pi 3 supports aarch64.";
    };

    system.build.installBootLoader = builder;
    system.boot.loader.id = "raspberrypi";
    system.boot.loader.kernelFile = platform.kernelTarget;
  };
}
