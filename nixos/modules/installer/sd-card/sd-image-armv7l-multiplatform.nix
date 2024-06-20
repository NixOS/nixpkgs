# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/base.nix
    ./sd-image.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # The serial ports listed here are:
  # - ttyS0: for Tegra (Jetson TK1)
  # - ttymxc0: for i.MX6 (Wandboard)
  # - ttyAMA0: for Allwinner (pcDuino3 Nano) and QEMU's -machine virt
  # - ttyO0: for OMAP (BeagleBone Black)
  # - ttySAC2: for Exynos (ODROID-XU3)
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];

  sdImage = {
    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        [pi2]
        kernel=u-boot-rpi2.bin

        [pi3]
        kernel=u-boot-rpi3.bin

        [pi4]
        kernel=u-boot-rpi4.bin
        enable_gic=1
        armstub=armstub8-32-gic.bin

        # Otherwise the resolution will be weird in most cases, compared to
        # what the pi3 firmware does by default.
        disable_overscan=1


        [all]
        # U-Boot needs this to work, regardless of whether UART is actually used or not.
        # Look in arch/arm/mach-bcm283x/Kconfig in the U-Boot tree to see if this is still
        # a requirement in the future.
        enable_uart=1

        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1

        ${config.sdImage.extraRpiFirmwareConfig}
      '';
      in ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
        cp ${pkgs.ubootRaspberryPi2}/u-boot.bin firmware/u-boot-rpi2.bin
        cp ${configTxt} firmware/config.txt

        # Add pi3 specific files
        cp ${pkgs.ubootRaspberryPi3_32bit}/u-boot.bin firmware/u-boot-rpi3.bin

        # Add pi4 specific files
        cp ${pkgs.ubootRaspberryPi4_32bit}/u-boot.bin firmware/u-boot-rpi4.bin
        cp ${pkgs.raspberrypi-armstubs}/armstub8-32-gic.bin firmware/armstub8-32-gic.bin
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb firmware/
      '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
