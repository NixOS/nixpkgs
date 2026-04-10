# Boot test for the minimal/bootable.nix profile.
#
# Builds a UKI + disk image (ESP + ext4 root via systemd-repart) from
# the minimal profile, then boots the image in QEMU with OVMF and
# verifies the system reaches a login prompt.
#
# The profile's toplevel has no test-driver backdoor agent, so the
# test uses OCR on the VGA console (wait_for_text / send_chars)
# instead of machine.succeed().
{
  pkgs,
  lib,
  ...
}:
let
  nixosLib = import (pkgs.path + "/nixos/lib/default.nix") {
    featureFlags.minimalModules = { };
  };

  nixos = nixosLib.evalModules {
    modules = [
      ../modules/profiles/minimal/bootable.nix
      ../modules/image/repart.nix
      # repart.nix imports repart-verity-store.nix which sets
      # boot.initrd.systemd.dmVerity.enable, so we need dm-verity.nix
      # for the option declaration (not actually used).
      ../modules/system/boot/systemd/dm-verity.nix
      {
        nixpkgs.pkgs = pkgs;

        boot.initrd.systemd.enable = true;
        boot.loader.efi.canTouchEfiVariables = false;

        # Kernel modules needed to mount the root FS
        boot.initrd.availableKernelModules = [
          "ext4"
          "sd_mod"
          "ahci"
          "virtio_blk"
          "virtio_pci"
        ];

        # Emit to serial and VGA so OCR works and logs are captured
        boot.kernelParams = [
          "console=ttyS0,115200"
          "console=tty0"
        ];

        # Passwordless root for the OCR login step
        users.users.root.initialHashedPassword = "";

        # Image metadata (used by UKI filename and os-release)
        system.image.id = "minimal-nixos";
        system.image.version = "1";

        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
        fileSystems."/boot" = {
          device = "/dev/disk/by-label/ESP";
          fsType = "vfat";
        };

        # GPT disk image: ESP partition containing the UKI, plus ext4 root.
        image.repart = {
          sectorSize = 512; # OVMF doesn't support 4096-byte sectors
          partitions = {
            "10-esp" = {
              contents = {
                "/EFI/BOOT/BOOTX64.EFI".source =
                  "${nixos.config.system.build.uki}/${nixos.config.system.boot.loader.ukiFile}";
              };
              repartConfig = {
                Type = "esp";
                Format = "vfat";
                SizeMinBytes = "64M";
              };
            };
            "20-root" = {
              storePaths = [ nixos.config.system.build.toplevel ];
              repartConfig = {
                Type = "root";
                Format = "ext4";
                Label = "nixos";
                Minimize = "guess";
              };
            };
          };
        };

        system.stateVersion = "26.05";
      }
    ];
  };

  image = nixos.config.system.build.image;
  diskImage = "${image}/${nixos.config.image.fileName}";
in
{
  name = "minimal-bootable";

  enableOCR = true;

  nodes.machine = {
    # The test runner itself is a full NixOS system — we override
    # its disk image with our pre-built minimal one via
    # NIX_DISK_IMAGE in the test script.
    virtualisation.directBoot.enable = false;
    virtualisation.mountHostNixStore = false;
    virtualisation.useEFIBoot = true;
    virtualisation.fileSystems = lib.mkForce {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
    };
    boot.loader.grub.enable = false;
  };

  testScript = ''
    import os
    import subprocess
    import tempfile

    # Copy the read-only image to a writable qcow2 overlay.
    tmp_disk_image = tempfile.NamedTemporaryFile()
    subprocess.run(
        [
            "${pkgs.qemu_kvm}/bin/qemu-img",
            "create",
            "-f",
            "qcow2",
            "-b",
            "${diskImage}",
            "-F",
            "raw",
            tmp_disk_image.name,
        ],
        check=True,
    )
    os.environ["NIX_DISK_IMAGE"] = tmp_disk_image.name

    machine.start()

    # Wait for the login prompt on the VGA console.
    machine.wait_for_text("login:", timeout=120)

    # Log in as root with the empty password and verify the shell
    # is reachable via OCR.
    machine.send_chars("root\n")
    machine.wait_for_text("root@nixos", timeout=30)

    # systemctl is-system-running --wait blocks until boot is
    # complete and reports running/degraded/…; the OCR needs a
    # single word to match.
    machine.send_chars("systemctl is-system-running --wait\n")
    machine.wait_for_text("running", timeout=60)

    machine.send_chars("hostname\n")
    machine.wait_for_text("nixos", timeout=10)

    machine.send_chars("poweroff\n")
    machine.wait_for_console_text("Power down", timeout=30)
  '';
}
