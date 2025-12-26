# Tests that you can boot from an external disk image with the qemu-vm module.
# "External" here means that the image was not produced within the qemu-vm
# module and relies on the fileSystems option also set outside the qemu-vm
# module. Most notably, this tests that you can stop the qemu-vm module from
# overriding fileSystems with virtualisation.fileSystems so you don't have to
# replicate the previously set fileSystems in virtualisation.fileSystems.

{ lib, ... }:

let
  rootFslabel = "external";
  rootFsDevice = "/dev/disk/by-label/${rootFslabel}";

  externalModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      boot.loader.systemd-boot.enable = true;

      fileSystems = {
        "/".device = rootFsDevice;
      };

      system.switch.enable = true;

      system.build.diskImage = import ../lib/make-disk-image.nix {
        inherit config lib pkgs;
        label = rootFslabel;
        partitionTableType = "efi";
        format = "qcow2";
        bootSize = "32M";
        additionalSpace = "0M";
        copyChannel = false;
      };
    };
in
{
  name = "qemu-vm-external-disk-image";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      virtualisation.directBoot.enable = false;
      virtualisation.mountHostNixStore = false;
      virtualisation.useEFIBoot = true;

      # This stops the qemu-vm module from overriding the fileSystems option
      # with virtualisation.fileSystems.
      virtualisation.fileSystems = lib.mkForce { };

      imports = [ externalModule ];
    };

  testScript =
    { nodes, ... }:
    ''
      import os
      import subprocess
      import tempfile

      tmp_disk_image = tempfile.NamedTemporaryFile()

      subprocess.run([
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
        "create",
        "-f",
        "qcow2",
        "-b",
        "${nodes.machine.system.build.diskImage}/nixos.qcow2",
        "-F",
        "qcow2",
        tmp_disk_image.name,
      ])

      # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      machine.succeed("findmnt --kernel --source ${rootFsDevice} --target /")

      # Make sure systemd boot didn't clobber this
      machine.succeed("[ ! -e /homeless-shelter ]")
    '';
}
