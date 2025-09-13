{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;
  qemu-common = import ../lib/qemu-common.nix { inherit lib pkgs; };

  mkStartCommand =
    {
      memory ? 2048,
      cdrom ? null,
      usb ? null,
      pxe ? null,
      uboot ? false,
      uefi ? false,
      extraFlags ? [ ],
    }:
    let
      qemu = qemu-common.qemuBinary pkgs.qemu_test;

      flags = [
        "-m"
        (toString memory)
        "-netdev"
        ("user,id=net0" + (lib.optionalString (pxe != null) ",tftp=${pxe},bootfile=netboot.ipxe"))
        "-device"
        (
          "virtio-net-pci,netdev=net0"
          + (lib.optionalString (pxe != null && uefi) ",romfile=${pkgs.ipxe}/ipxe.efirom")
        )
      ]
      ++ lib.optionals (cdrom != null) [
        "-cdrom"
        cdrom
      ]
      ++ lib.optionals (usb != null) [
        "-device"
        "usb-ehci"
        "-drive"
        "id=usbdisk,file=${usb},if=none,readonly"
        "-device"
        "usb-storage,drive=usbdisk"
      ]
      ++ lib.optionals (pxe != null) [
        "-boot"
        "order=n"
      ]
      ++ lib.optionals uefi [
        "-drive"
        "if=pflash,format=raw,unit=0,readonly=on,file=${pkgs.OVMF.firmware}"
        "-drive"
        "if=pflash,format=raw,unit=1,readonly=on,file=${pkgs.OVMF.variables}"
      ]
      ++ extraFlags;

      flagsStr = lib.concatStringsSep " " flags;
    in
    "${qemu} ${flagsStr}";

  iso =
    (import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../modules/installer/cd-dvd/installation-cd-minimal.nix
        ../modules/testing/test-instrumentation.nix
        { nixpkgs.pkgs = pkgs; }
      ];
    }).config.system.build.isoImage;

  sd =
    (import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../modules/installer/sd-card/sd-image-x86_64.nix
        ../modules/testing/test-instrumentation.nix
        {
          sdImage.compressImage = false;
          nixpkgs.pkgs = pkgs;
        }
      ];
    }).config.system.build.sdImage;

  makeBootTest =
    name: config:
    let
      startCommand = mkStartCommand config;
    in
    makeTest {
      name = "boot-" + name;
      nodes = { };
      testScript = ''
        machine = create_machine("${startCommand}")
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("nix store verify --no-trust -r --option experimental-features nix-command /run/current-system")

        with subtest("Check whether the channel got installed correctly"):
            machine.succeed("nix-instantiate --dry-run '<nixpkgs>' -A hello")
            machine.succeed("nix-env --dry-run -iA nixos.procps")

        machine.shutdown()
      '';
    };

  makeVentoyTest =
    name: config:
    let
      startCommand = mkStartCommand (
        builtins.removeAttrs config [ "ventoyFile" ]
        // {
          usb = "$NIX_BUILD_TOP/ventoy.qcow2";
        }
      );

      ventoyJSON = pkgs.writeText "ventoy.json" (
        builtins.toJSON {
          control = [
            { VTOY_DEFAULT_IMAGE = baseNameOf config.ventoyFile; }
            { VTOY_MENU_TIMEOUT = "0"; }
            { VTOY_SECONDARY_BOOT_MENU = "0"; }
          ];
        }
      );
    in
    makeTest {
      name = "boot-ventoy-${name}";
      nodes.setup = {
        environment.systemPackages = [ pkgs.ventoy ];
        virtualisation.qemu.drives = [
          {
            file = "$NIX_BUILD_TOP/ventoy.qcow2";
            deviceExtraOpts.serial = "ventoy";
          }
        ];
      };

      testScript =
        { nodes, ... }:
        ''
          import os, math, subprocess
          from pathlib import Path

          iso_size = os.path.getsize("${config.ventoyFile}")
          mebibyte = 1024 * 1024
          # 256MiB larger than the ISO size rounded up to the nearest MiB
          drive_size = (256 * mebibyte) + (math.ceil(iso_size / mebibyte) * mebibyte)
          drive_path = Path(os.environ["NIX_BUILD_TOP"]) / "ventoy.qcow2"

          subprocess.run([
            "${nodes.setup.virtualisation.qemu.package}/bin/qemu-img",
            "create",
            "-f",
            "qcow2",
            drive_path,
            f"{drive_size}",
          ])

          setup.succeed(
            # Not sure why ventoy exits 1
            "yes | ventoy -i -g /dev/disk/by-id/virtio-ventoy || true",
            "mkdir /mnt",
            "mount /dev/disk/by-id/virtio-ventoy-part1 /mnt",
            "cp -v ${config.ventoyFile} /mnt/",
            "mkdir /mnt/ventoy",
            "cp -v ${ventoyJSON} /mnt/ventoy/ventoy.json",
            "umount /mnt",
          )
          setup.shutdown()

          machine = create_machine("${startCommand}")
          machine.start()
          machine.wait_for_unit("multi-user.target")
          machine.succeed("stat /run/ventoy/${baseNameOf config.ventoyFile}")
          machine.shutdown()
        '';
    };

  makeNetbootTest =
    name: extraConfig:
    let
      config =
        (import ../lib/eval-config.nix {
          system = null;
          modules = [
            ../modules/installer/netboot/netboot.nix
            ../modules/testing/test-instrumentation.nix
            {
              boot.kernelParams = [
                "serial"
                "live.nixos.passwordHash=$6$jnwR50SkbLYEq/Vp$wmggwioAkfmwuYqd5hIfatZWS/bO6hewzNIwIrWcgdh7k/fhUzZT29Vil3ioMo94sdji/nipbzwEpxecLZw0d0" # "password"
              ];

              nixpkgs.pkgs = pkgs;
            }
            {
              key = "serial";
            }
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
      startCommand = mkStartCommand (
        {
          pxe = ipxeBootDir;
        }
        // extraConfig
      );
    in
    makeTest {
      name = "boot-netboot-" + name;
      nodes = { };
      testScript = ''
        machine = create_machine("${startCommand}")
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("grep 'serial' /proc/cmdline")
        machine.succeed("grep 'live.nixos.passwordHash' /proc/cmdline")
        machine.succeed("grep '$6$jnwR50SkbLYEq/Vp$wmggwioAkfmwuYqd5hIfatZWS/bO6hewzNIwIrWcgdh7k/fhUzZT29Vil3ioMo94sdji/nipbzwEpxecLZw0d0' /etc/shadow")
        machine.shutdown()
      '';
    };
in
{
  uefiCdrom = makeBootTest "uefi-cdrom" {
    uefi = true;
    cdrom = "${iso}/iso/${iso.isoName}";
  };

  uefiUsb = makeBootTest "uefi-usb" {
    uefi = true;
    usb = "${iso}/iso/${iso.isoName}";
  };

  uefiVentoy = makeVentoyTest "uefi-ventoy" {
    uefi = true;
    ventoyFile = "${iso}/iso/${iso.isoName}";
  };

  uefiNetboot = makeNetbootTest "uefi" {
    uefi = true;
  };
}
// lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  biosCdrom = makeBootTest "bios-cdrom" {
    cdrom = "${iso}/iso/${iso.isoName}";
  };

  biosUsb = makeBootTest "bios-usb" {
    usb = "${iso}/iso/${iso.isoName}";
  };

  biosVentoy = makeVentoyTest "uefi-ventoy" {
    ventoyFile = "${iso}/iso/${iso.isoName}";
  };

  biosNetboot = makeNetbootTest "bios" { };

  ubootExtlinux =
    let
      sdImage = "${sd}/sd-image/${sd.imageName}";
      mutableImage = "/tmp/linked-image.qcow2";

      startCommand = mkStartCommand {
        extraFlags = [
          "-bios"
          "${pkgs.ubootQemuX86}/u-boot.rom"
          "-machine"
          "type=pc,accel=tcg"
          "-drive"
          "file=${mutableImage},if=virtio"
        ];
      };
    in
    makeTest {
      name = "boot-uboot-extlinux";
      nodes = { };
      testScript = ''
        import os

        # Create a mutable linked image backed by the read-only SD image
        if os.system("qemu-img create -f qcow2 -F raw -b ${sdImage} ${mutableImage}") != 0:
            raise RuntimeError("Could not create mutable linked image")

        machine = create_machine("${startCommand}")
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("nix store verify -r --no-trust --option experimental-features nix-command /run/current-system")
        machine.shutdown()
      '';

      # kernel can't find rootfs after boot - investigate?
      meta.broken = true;
    };
}
