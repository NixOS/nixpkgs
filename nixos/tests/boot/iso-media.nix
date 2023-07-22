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

  makeBootTest = name: bootloaders: extraMachineConfig:
      makeTest {
        name = "boot-" + name + "-with-${concatStringsSep "," bootloaders}";
        nodes.machine = {
          imports = [ extraMachineConfig ];

          boot.loader.enabled = mkForce bootloaders;

          virtualisation.useBootLoader = true;
          virtualisation.memorySize = 768;
        };
        testScript =
          ''
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("nix store verify --no-trust -r --option experimental-features nix-command /run/current-system")

            with subtest("Check whether the channel got installed correctly"):
                machine.succeed("nix-instantiate --dry-run '<nixpkgs>' -A hello")
                machine.succeed("nix-env --dry-run -iA nixos.procps")

            machine.shutdown()
          '';
        };

    makeBootMediaTests = bootloaders: {
      uefiCdrom = makeBootTest "uefi-cdrom" bootloaders {
        virtualisation.useEFIBoot = true;
        virtualisation.qemu.options = [ "cdrom=${iso}/iso/${iso.isoName}" ];
      };

      uefiUsb = makeBootTest "uefi-usb" bootloaders {
        virtualisation.useEFIBoot = true;
        virtualisation.qemu.options = [ "usb=${iso}/iso/${iso.isoName}" ];
      };

  } // optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      biosCdrom = makeBootTest "bios-cdrom" bootloaders {
        virtualisation.qemu.options = [ "cdrom=${iso}/iso/${iso.isoName}" ];
      };

      biosUsb = makeBootTest "bios-usb" bootloaders {
        virtualisation.qemu.options = [ "usb=${iso}/iso/${iso.isoName}" ];
      };
    };

in
  {
    grub-only = makeBootMediaTests [ "grub" ];
    hybrid = makeBootMediaTests [ "grub" "systemd-boot" ];
  }
