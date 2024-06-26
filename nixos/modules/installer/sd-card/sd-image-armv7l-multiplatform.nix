# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix -A config.system.build.sdImage
{
  config,
  lib,
  pkgs,
  ...
}:

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
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=ttymxc0,115200n8"
    "console=ttyAMA0,115200n8"
    "console=ttyO0,115200n8"
    "console=ttySAC2,115200n8"
    "console=tty0"
  ];

  sdImage = {
    populateFirmwareCommands =
      let
        configTxt = pkgs.writeText "config.txt" ''
          # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
          # when attempting to show low-voltage or overtemperature warnings.
          avoid_warnings=1

          [pi2]
          kernel=u-boot-rpi2.bin

          [pi3]
          kernel=u-boot-rpi3.bin

          # U-Boot used to need this to work, regardless of whether UART is actually used or not.
          # TODO: check when/if this can be removed.
          enable_uart=1
        '';
      in
      ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
        cp ${pkgs.ubootRaspberryPi2}/u-boot.bin firmware/u-boot-rpi2.bin
        cp ${pkgs.ubootRaspberryPi3_32bit}/u-boot.bin firmware/u-boot-rpi3.bin
        cp ${configTxt} firmware/config.txt
      '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
