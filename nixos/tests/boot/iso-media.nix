{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  iso =
    (import ../../lib/eval-config.nix {
      inherit system;
      modules = [
        ../../modules/installer/cd-dvd/installation-cd-minimal.nix
        ../../modules/testing/test-instrumentation.nix
      ];
    }).config.system.build.isoImage;

  makeBootTest = name: bootloaders: { config, postTestScript ? "" }:
      makeTest {
        name = "boot-" + name + "-with-${concatStringsSep "," bootloaders}";
        nodes.machine = {
          imports = [ config ];

          boot.loader = listToAttrs (map (bootloader: { name = bootloader; value.enable = true; }) bootloaders);

          virtualisation.diskImage = null;
          virtualisation.useBootLoader = true;
          virtualisation.memorySize = 1024;
        };
        testScript =
          ''
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("nix store verify --no-trust -r --option experimental-features nix-command /run/current-system")

            with subtest("Check whether the channel got installed correctly"):
                machine.succeed("nix-instantiate --dry-run '<nixpkgs>' -A hello")
                machine.succeed("nix-env --dry-run -iA nixos.procps")

            ${postTestScript}

            machine.shutdown()
          '';
        };

    makeBootMediaTests = bootloaders: {
      uefiCdrom = makeBootTest "uefi-cdrom" bootloaders { config = {
          virtualisation.useEFIBoot = true;
          virtualisation.qemu.options = [
            "-drive file=${iso}/iso/${iso.isoName},format=raw,if=none,media=cdrom,id=bootcd,readonly=on"
            "-device ahci,id=ahci0"
            "-device ide-cd,bus=ahci0.0,drive=bootcd,id=cd1,bootindex=1"
          ];
        };
      };

      uefiUsb = makeBootTest "uefi-usb" bootloaders { config = {
          virtualisation.useEFIBoot = true;
          virtualisation.qemu.options = [
            "-drive file=${iso}/iso/${iso.isoName},format=raw,if=none,id=bootstick,readonly=on"
            "-device nec-usb-xhci,id=xhci"
            "-device usb-storage,bus=xhci.0,drive=bootstick"
          ];
        };
      };

  } // optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      biosCdrom = makeBootTest "bios-cdrom" bootloaders {
        config = {
          virtualisation.qemu.options = [
            "-drive file=${iso}/iso/${iso.isoName},format=raw,if=none,media=cdrom,id=bootcd,readonly=on"
            "-device ahci,id=ahci0"
            "-device ide-cd,bus=ahci0.0,drive=bootcd,id=cd1,bootindex=1"
          ];
        };
      };

      biosUsb = makeBootTest "bios-usb" bootloaders { config = {
        virtualisation.qemu.options = [
          "-drive file=${iso}/iso/${iso.isoName},format=raw,if=none,id=bootstick,readonly=on"
          "-device nec-usb-xhci,id=xhci"
          "-device usb-storage,bus=xhci.0,drive=bootstick"
        ];
      };
    }; };

in
  {
    grub-only = makeBootMediaTests [ "grub" ];
    # systemd-boot only works on UEFI
    hybrid = builtins.removeAttrs (makeBootMediaTests [ "grub" "systemd-boot" ]) [ "biosCdrom" "biosUsb" ];
  }
