{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let

  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-minimal.nix
          ../modules/testing/test-instrumentation.nix
        ];
    }).config.system.build.isoImage;

  sd =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/sd-card/sd-image-x86_64.nix
          ../modules/testing/test-instrumentation.nix
          { sdImage.compressImage = false; }
        ];
    }).config.system.build.sdImage;

  pythonDict = params: "\n    {\n        ${concatStringsSep ",\n        " (mapAttrsToList (name: param: "\"${name}\": \"${param}\"") params)},\n    }\n";

  makeBootTest = name: extraConfig:
    let
      machineConfig = pythonDict ({ qemuFlags = "-m 768"; } // extraConfig);
    in
      makeTest {
        inherit iso;
        name = "boot-" + name;
        nodes = { };
        testScript =
          ''
            machine = create_machine(${machineConfig})
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("nix verify -r --no-trust /run/current-system")

            with subtest("Check whether the channel got installed correctly"):
                machine.succeed("nix-instantiate --dry-run '<nixpkgs>' -A hello")
                machine.succeed("nix-env --dry-run -iA nixos.procps")

            machine.shutdown()
          '';
      };

  makeNetbootTest = name: extraConfig:
    let
      config = (import ../lib/eval-config.nix {
          inherit system;
          modules =
            [ ../modules/installer/netboot/netboot.nix
              ../modules/testing/test-instrumentation.nix
              { key = "serial"; }
            ];
        }).config;
      ipxeBootDir = pkgs.symlinkJoin {
        name = "ipxeBootDir";
        paths = [
          config.system.build.netbootRamdisk
          config.system.build.kernel
          config.system.build.netbootIpxeScript
        ];
      };
      machineConfig = pythonDict ({
        qemuFlags = "-boot order=n -m 2000";
        netBackendArgs = "tftp=${ipxeBootDir},bootfile=netboot.ipxe";
      } // extraConfig);
    in
      makeTest {
        name = "boot-netboot-" + name;
        nodes = { };
        testScript = ''
            machine = create_machine(${machineConfig})
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.shutdown()
          '';
      };
in {

    biosCdrom = makeBootTest "bios-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
    };

    biosUsb = makeBootTest "bios-usb" {
      usb = "${iso}/iso/${iso.isoName}";
    };

    uefiCdrom = makeBootTest "uefi-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
    };

    uefiUsb = makeBootTest "uefi-usb" {
      usb = "${iso}/iso/${iso.isoName}";
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
    };

    biosNetboot = makeNetbootTest "bios" {};

    uefiNetboot = makeNetbootTest "uefi" {
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
      # Custom ROM is needed for EFI PXE boot. I failed to understand exactly why, because QEMU should still use iPXE for EFI.
      netFrontendArgs = "romfile=${pkgs.ipxe}/ipxe.efirom";
    };

    ubootExtlinux = makeBootTest "uboot-extlinux" {
      usb = "${sd}/sd-image/${sd.imageName}";
      bios = "${pkgs.ubootQemuX86_64}/u-boot.rom";
    };
}
