# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-raspberrypi.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

let
  extlinux-conf-builder =
    import ../../system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };
in
{
  imports = [
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
    ./sd-image.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "armv6l-linux";
    message = "sd-image-raspberrypi.nix can be only built natively on ARMv6; " +
      "it cannot be cross compiled";
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_rpi;

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";

  sdImage = {
    populateBootCommands = ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/boot/)
      cp ${pkgs.ubootRaspberryPi}/u-boot.bin boot/u-boot-rpi.bin
      echo 'kernel u-boot-rpi.bin' > boot/config.txt
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };
}
