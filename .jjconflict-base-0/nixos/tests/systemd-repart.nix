{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  # A testScript fragment that prepares a disk with some empty, unpartitioned
  # space. and uses it to boot the test with. Takes a single argument `machine`
  # from which the diskImage is extracted.
  useDiskImage = machine: ''
    import os
    import shutil
    import subprocess
    import tempfile

    tmp_disk_image = tempfile.NamedTemporaryFile()

    shutil.copyfile("${machine.system.build.diskImage}/nixos.img", tmp_disk_image.name)

    subprocess.run([
      "${machine.config.virtualisation.qemu.package}/bin/qemu-img",
      "resize",
      "-f",
      "raw",
      tmp_disk_image.name,
      "+32M",
    ])

    # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
    os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name
  '';

  common =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      virtualisation.useDefaultFilesystems = false;
      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/vda2";
          fsType = "ext4";
        };
      };

      # systemd-repart operates on disks with a partition table. The qemu module,
      # however, creates separate filesystem images without a partition table, so
      # we have to create a disk image manually.
      #
      # This creates two partitions, an ESP available as /dev/vda1 and the root
      # partition available as /dev/vda2.
      system.build.diskImage = import ../lib/make-disk-image.nix {
        inherit config pkgs lib;
        # Use a raw format disk so that it can be resized before starting the
        # test VM.
        format = "raw";
        # Keep the image as small as possible but leave some room for changes.
        bootSize = "32M";
        additionalSpace = "0M";
        # GPT with an EFI System Partition is the typical use case for
        # systemd-repart because it does not support MBR.
        partitionTableType = "efi";
        # We do not actually care much about the content of the partitions, so we
        # do not need a bootloader installed.
        installBootLoader = false;
        # Improve determinism by not copying a channel.
        copyChannel = false;
      };
    };
in
{
  basic = makeTest {
    name = "systemd-repart";
    meta.maintainers = with maintainers; [ nikstur ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        imports = [ common ];

        boot.initrd.systemd.enable = true;

        boot.initrd.systemd.repart.enable = true;
        systemd.repart.partitions = {
          "10-root" = {
            Type = "linux-generic";
          };
        };
      };

    testScript =
      { nodes, ... }:
      ''
        ${useDiskImage nodes.machine}

        machine.start()
        machine.wait_for_unit("multi-user.target")

        systemd_repart_logs = machine.succeed("journalctl --boot --unit systemd-repart.service")
        assert "Growing existing partition 1." in systemd_repart_logs
      '';
  };

  after-initrd = makeTest {
    name = "systemd-repart-after-initrd";
    meta.maintainers = with maintainers; [ nikstur ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        imports = [ common ];

        systemd.repart.enable = true;
        systemd.repart.partitions = {
          "10-root" = {
            Type = "linux-generic";
          };
        };
      };

    testScript =
      { nodes, ... }:
      ''
        ${useDiskImage nodes.machine}

        machine.start()
        machine.wait_for_unit("multi-user.target")

        systemd_repart_logs = machine.succeed("journalctl --unit systemd-repart.service")
        assert "Growing existing partition 1." in systemd_repart_logs
      '';
  };

  create-root = makeTest {
    name = "systemd-repart-create-root";
    meta.maintainers = with maintainers; [ nikstur ];

    nodes.machine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        virtualisation.useDefaultFilesystems = false;
        virtualisation.fileSystems = {
          "/" = {
            device = "/dev/disk/by-partlabel/created-root";
            fsType = "ext4";
          };
          "/nix/store" = {
            device = "/dev/vda2";
            fsType = "ext4";
          };
        };

        # Create an image containing only the Nix store. This enables creating
        # the root partition with systemd-repart and then successfully booting
        # into a working system.
        #
        # This creates two partitions, an ESP available as /dev/vda1 and the Nix
        # store available as /dev/vda2.
        system.build.diskImage = import ../lib/make-disk-image.nix {
          inherit config pkgs lib;
          onlyNixStore = true;
          format = "raw";
          bootSize = "32M";
          additionalSpace = "0M";
          partitionTableType = "efi";
          installBootLoader = false;
          copyChannel = false;
        };

        boot.initrd.systemd.enable = true;

        boot.initrd.systemd.repart.enable = true;
        boot.initrd.systemd.repart.device = "/dev/vda";
        systemd.repart.partitions = {
          "10-root" = {
            Type = "root";
            Label = "created-root";
            Format = "ext4";
          };
        };
      };

    testScript =
      { nodes, ... }:
      ''
        ${useDiskImage nodes.machine}

        machine.start()
        machine.wait_for_unit("multi-user.target")

        systemd_repart_logs = machine.succeed("journalctl --boot --unit systemd-repart.service")
        assert "Adding new partition 2 to partition table." in systemd_repart_logs
      '';
  };
}
