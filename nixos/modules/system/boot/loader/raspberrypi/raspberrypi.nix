{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;
  blCfg = config.boot.loader;


  firmwareBuilder = pkgs.callPackage ./firmware-builder.nix {
    inherit (cfg) version;
    ubootEnabled = cfg.uboot.enable;
  };
  raspberryPiBuilder = pkgs.callPackage ./raspberrypi-builder.nix { };

  builder = pkgs.writeScript "install-raspberrypi-bootloader.sh" (''
    #!${pkgs.runtimeShell}
    '${firmwareBuilder}' -d '${cfg.firmwareDir}' -c '${configTxt}'
  '' + (if cfg.uboot.enable then ''
    ${config.boot.loader.generic-extlinux-compatible.installCmd} -c "$@"
  '' else ''
    '${raspberryPiBuilder}' -d '${cfg.firmwareDir}' -c "$@"
  ''));

  configTxt = pkgs.writeText "config.txt" cfg.firmwareConfig;
in

{
  imports = [
    (mkRenamedOptionModule [ "boot" "loader" "raspberryPi" "uboot" "configurationLimit" ] [ "boot" "loader" "generic-extlinux-compatible" "configurationLimit" ])
  ];

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

      uboot.enable = mkEnableOption (lib.mdDoc "U-Boot as the bootloader for the Raspberry Pi");

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

    boot.loader.generic-extlinux-compatible.enable = mkIf cfg.uboot.enable true;

    # Override the generic-extlinux-compatible builder (if enabled) with our own
    system.build.installBootLoader = mkForce builder;
    system.boot.loader.id = mkForce "raspberrypi";
    system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;
  };
}
