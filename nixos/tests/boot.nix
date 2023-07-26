{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  qemu-common = import ../lib/qemu-common.nix { inherit (pkgs) lib pkgs; };

  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../modules/installer/cd-dvd/installation-cd-minimal.nix
        ../modules/testing/test-instrumentation.nix
      ];
    }).config.system.build.isoImage;

  sd =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../modules/installer/sd-card/sd-image-x86_64.nix
        ../modules/testing/test-instrumentation.nix
        { sdImage.compressImage = false; }
      ];
    }).config.system.build.sdImage;

  pythonDict = params: "\n    {\n        ${concatStringsSep ",\n        " (mapAttrsToList (name: param: "\"${name}\": \"${param}\"") params)},\n    }\n";

  makeBootTest = name: extraConfig:
    let
      machineConfig = pythonDict ({
        qemuBinary = qemu-common.qemuBinary pkgs.qemu_test;
        qemuFlags = "-m 768";
      } // extraConfig);
    in
      makeTest {
        name = "boot-" + name;
        nodes = { };
        testScript =
          ''
            machine = create_machine(${machineConfig})
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("nix store verify --no-trust -r --option experimental-features nix-command /run/current-system")

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
        qemuBinary = qemu-common.qemuBinary pkgs.qemu_test;
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
  uefiBinary = {
    x86_64-linux = "${pkgs.OVMF.fd}/FV/OVMF.fd";
    aarch64-linux = "${pkgs.OVMF.fd}/FV/QEMU_EFI.fd";
  }.${pkgs.stdenv.hostPlatform.system};
in {
    uefiCdrom = makeBootTest "uefi-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
      bios = uefiBinary;
    };

    uefiUsb = makeBootTest "uefi-usb" {
      usb = "${iso}/iso/${iso.isoName}";
      bios = uefiBinary;
    };

    uefiNetboot = makeNetbootTest "uefi" {
      bios = uefiBinary;
      # Custom ROM is needed for EFI PXE boot. I failed to understand exactly why, because QEMU should still use iPXE for EFI.
      netFrontendArgs = "romfile=${pkgs.ipxe}/ipxe.efirom";
    };
} // optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    biosCdrom = makeBootTest "bios-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
    };

    biosUsb = makeBootTest "bios-usb" {
      usb = "${iso}/iso/${iso.isoName}";
    };

    biosNetboot = makeNetbootTest "bios" {};

    ubootExtlinux = let
      sdImage = "${sd}/sd-image/${sd.imageName}";
      mutableImage = "/tmp/linked-image.qcow2";

      machineConfig = pythonDict {
        bios = "${pkgs.ubootQemuX86}/u-boot.rom";
        qemuFlags = "-m 768 -machine type=pc,accel=tcg -drive file=${mutableImage},if=ide,format=qcow2";
      };
    in makeTest {
      name = "boot-uboot-extlinux";
      nodes = { };
      testScript = ''
        import os

        # Create a mutable linked image backed by the read-only SD image
        if os.system("qemu-img create -f qcow2 -F raw -b ${sdImage} ${mutableImage}") != 0:
            raise RuntimeError("Could not create mutable linked image")

        machine = create_machine(${machineConfig})
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("nix store verify -r --no-trust --option experimental-features nix-command /run/current-system")
        machine.shutdown()
      '';
    };
}
