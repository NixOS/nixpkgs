# Tests building and running a GUID Partition Table (GPT) appliance image.
# "Appliance" here means that the image does not contain the normal NixOS
# infrastructure of a system profile and cannot be re-built via
# `nixos-rebuild`.

{ lib, ... }:

let rootPartitionLabel = "root";
in {
  name = "appliance-gpt-image";

  meta.maintainers = with lib.maintainers; [ arianvp ];

  defaults = { lib, ... }: {
    imports = [ ../modules/image/amazon.nix ];

    virtualisation.directBoot.enable = false;
    virtualisation.mountHostNixStore = false;
    virtualisation.installBootLoader = true;

    virtualisation.fileSystems = lib.mkForce {
      "/" = {
        device = "/dev/disk/by-partlabel/root";
        fsType = "ext4";
      };
    };

    image.repart = {
      # OVMF does not work with the default repart sector size of 4096
      sectorSize = 512;
    };
  };

  nodes.uefi = { virtualisation.useEFIBoot = true; };
  nodes.bios = { virtualisation.useEFIBoot = false; };

  testScript = { nodes, ... }: ''
    import os
    import subprocess
    import tempfile

    tmp_disk_image = tempfile.NamedTemporaryFile()

    subprocess.run([
      "${nodes.uefi.virtualisation.qemu.package}/bin/qemu-img",
      "create",
      "-f",
      "qcow2",
      "-b",
      "${nodes.uefi.system.build.finalImage}/${nodes.uefi.image.repart.imageFile}",
      "-F",
      "raw",
      tmp_disk_image.name,
    ])

    # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
    os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name
    uefi.wait_for_unit("default.target")
  '';
}
