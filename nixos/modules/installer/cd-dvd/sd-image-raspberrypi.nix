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
    assertion = pkgs.stdenv.system == "armv6l-linux";
    message = "sd-image-raspberrypi.nix can be only built natively on ARMv6; " +
      "it cannot be cross compiled";
  };

  # Needed by RPi firmware
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_rpi;
  boot.consoleLogLevel = 7;

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";

  sdImage = {
    populateBootCommands = ''
      for f in bootcode.bin fixup.dat start.elf; do
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/$f boot/
      done
      cp ${pkgs.ubootRaspberryPi}/u-boot.bin boot/u-boot-rpi.bin
      echo 'kernel u-boot-rpi.bin' > boot/config.txt
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };
}
