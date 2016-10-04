{ config, lib, pkgs, ... }:

let
  extlinux-conf-builder =
    import ../../system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };
in
{
  imports = [
    ../../profiles/minimal.nix
    ../../profiles/installation-device.nix
    ./sd-image.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "armv7l-linux";
    message = "sd-image-armv7l-multiplatform.nix can be only built natively on ARMv7; " +
      "it cannot be cross compiled";
  };

  # Needed by RPi firmware
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=tty0"];
  boot.consoleLogLevel = 7;

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";

  sdImage = {
    populateBootCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        [pi2]
        kernel=u-boot-rpi2.bin

        [pi3]
        kernel=u-boot-rpi3.bin
        enable_uart=1
      '';
      in ''
        for f in bootcode.bin fixup.dat start.elf; do
          cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/$f boot/
        done
        cp ${pkgs.ubootRaspberryPi2}/u-boot.bin boot/u-boot-rpi2.bin
        cp ${pkgs.ubootRaspberryPi3}/u-boot.bin boot/u-boot-rpi3.bin
        cp ${configTxt} boot/config.txt
        ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
      '';
  };
}
