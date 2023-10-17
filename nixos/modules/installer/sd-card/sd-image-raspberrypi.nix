# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-raspberrypi.nix -A config.system.build.sdImage
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
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi1;

  sdImage = {
    firmwarePartitionContents =
      let
        configTxt = pkgs.writeText "config.txt" ''
          # u-boot refuses to start (gets stuck at rainbow polygon) without this,
          # at least on Raspberry Pi 0.
          enable_uart=1

          # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
          # when attempting to show low-voltage or overtemperature warnings.
          avoid_warnings=1

          [pi0]
          kernel=u-boot-rpi0.bin

          [pi1]
          kernel=u-boot-rpi1.bin
        '';
      in
      pkgs.runCommand "firmwarePartitionContents" { } ''
        mkdir $out
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $out)
        cp ${pkgs.ubootRaspberryPiZero}/u-boot.bin $out/u-boot-rpi0.bin
        cp ${pkgs.ubootRaspberryPi}/u-boot.bin $out/u-boot-rpi1.bin
        cp ${configTxt} $out/config.txt
      '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
