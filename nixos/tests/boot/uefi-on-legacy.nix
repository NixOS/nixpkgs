{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

assert pkgs.stdenv.hostPlatform.system == "x86_64-linux";
let
  iso =
    (import ../../lib/eval-config.nix {
      inherit system;
      modules = [
        ../../modules/installer/cd-dvd/installation-cd-minimal.nix
        ../../modules/testing/test-instrumentation.nix
      ];
    }).config.system.build.isoImage;

    makeBootTestWithCompatLayer = name: bootloaders: config:
    makeBootTest "${name}-with-uefi-compatibility" bootloaders {
      config = {
        imports = [ config ];

        boot.firmware.uefi-compatibility.enable = true;
      };

      postTestScript = ''
        with subtest("Assert UEFI environment is detected by Linux"):
          machine.succeed("test -d /sys/firmware/efi")
      '';
    };

    makeBootMediaTests = bootloaders: optionalAttrs  {
      biosCdrom = makeBootTestWithCompatLayer "bios-cdrom" bootloaders {
        virtualisation.qemu.options = [ "-cdrom=${iso}/iso/${iso.isoName}" ];
      };

      biosUsb = makeBootTestWithCompatLayer "bios-usb" bootloaders {
        virtualisation.qemu.options = [ "-usb=${iso}/iso/${iso.isoName}" ];
      };
    };

in
  {
    grub = makeBootMediaTests [ "grub" ];
    systemd-boot = makeBootMediaTests [ "systemd-boot" ];
  }
