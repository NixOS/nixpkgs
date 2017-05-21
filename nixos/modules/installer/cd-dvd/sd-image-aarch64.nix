# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-aarch64.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

let
  extlinux-conf-builder =
    import ../../system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };
in
{
  imports = [
    ../../profiles/installation-device.nix
    ./sd-image.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "aarch64-linux";
    message = "sd-image-aarch64.nix can be only built natively on Aarch64 / ARM64; " +
      "it cannot be cross compiled";
  };

  # Needed by RPi firmware
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=tty0"];
  boot.consoleLogLevel = 7;

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";

  sdImage = {
    populateBootCommands = let
      # Contains a couple of fixes for booting a Linux kernel, will hopefully appear upstream soon.
      patchedUboot = pkgs.ubootRaspberryPi3_64bit.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "dezgeg";
          repo = "u-boot";
          rev = "baab53ec244fe44def01948a0f10e67342d401e6";
          sha256 = "0r5j2pc42ws3w3im0a9c6bh01czz5kapqrqp0ik9ra823cw73lxr";
        };
      });

      configTxt = pkgs.writeText "config.txt" ''
        kernel=u-boot-rpi3.bin
        arm_control=0x200
        enable_uart=1
      '';
      in ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/boot/)
        cp ${patchedUboot}/u-boot.bin boot/u-boot-rpi3.bin
        cp ${configTxt} boot/config.txt
        ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
      '';
  };
}
