{ lib, ... }:

let
  rootFslabel = "external";
  rootFsDevice = "/dev/disk/by-label/${rootFslabel}";

  externalModule =
    partitionTableType:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      virtualisation.directBoot.enable = false;
      virtualisation.mountHostNixStore = false;
      virtualisation.useEFIBoot = partitionTableType == "efi";

      # This stops the qemu-vm module from overriding the fileSystems option
      # with virtualisation.fileSystems.
      virtualisation.fileSystems = lib.mkForce { };

      boot.loader.grub.enable = true;
      boot.loader.grub.efiSupport = partitionTableType == "efi";
      boot.loader.grub.efiInstallAsRemovable = partitionTableType == "efi";
      boot.loader.grub.device = if partitionTableType == "efi" then "nodev" else "/dev/vda";

      boot.growPartition = true;

      fileSystems = {
        "/".device = rootFsDevice;
      };

      system.build.diskImage = import ../lib/make-disk-image.nix {
        inherit config lib pkgs;
        label = rootFslabel;
        inherit partitionTableType;
        format = "raw";
        bootSize = "128M";
        additionalSpace = "0M";
        copyChannel = false;
      };
    };
in
{
  name = "grow-partition";

  meta.maintainers = with lib.maintainers; [ arianvp ];

  nodes = {
    efi = externalModule "efi";
    legacy = externalModule "legacy";
    legacyGPT = externalModule "legacy+gpt";
    hybrid = externalModule "hybrid";
  };

  testScript =
    { nodes, ... }:
    lib.concatLines (
      lib.mapAttrsToList (name: node: ''
        import os
        import subprocess
        import tempfile
        import shutil

        tmp_disk_image = tempfile.NamedTemporaryFile()

        shutil.copyfile("${node.system.build.diskImage}/nixos.img", tmp_disk_image.name)

        subprocess.run([
          "${node.virtualisation.qemu.package}/bin/qemu-img",
          "resize",
          "-f",
          "raw",
          tmp_disk_image.name,
          "+32M",
        ])

        # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
        os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

        ${name}.wait_for_unit("growpart.service")
        systemd_growpart_logs = ${name}.succeed("journalctl --boot --unit growpart.service")
        assert "CHANGED" in systemd_growpart_logs
        ${name}.succeed("systemctl restart growpart.service")
        systemd_growpart_logs = ${name}.succeed("journalctl --boot --unit growpart.service")
        assert "NOCHANGE" in systemd_growpart_logs

      '') nodes
    );
}
