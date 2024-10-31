# similar to the appliance-repart-image test but with a dm-verity
# protected nix store and tmpfs as rootfs
{ lib, ... }:

{
  name = "appliance-repart-image-verity-store";

  meta.maintainers = with lib.maintainers; [
    nikstur
    willibutz
  ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.image.repart.verityStore) partitionIds;
    in
    {
      imports = [ ../modules/image/repart.nix ];

      virtualisation.fileSystems = lib.mkVMOverride {
        "/" = {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
        };

        "/usr" = {
          device = "/dev/mapper/usr";
          # explicitly mount it read-only otherwise systemd-remount-fs will fail
          options = [ "ro" ];
          fsType = config.image.repart.partitions.${partitionIds.store}.repartConfig.Format;
        };

        # bind-mount the store
        "/nix/store" = {
          device = "/usr/nix/store";
          options = [ "bind" ];
        };
      };

      image.repart = {
        verityStore = {
          enable = true;
          # by default the module works with systemd-boot, for simplicity this test directly boots the UKI
          ukiPath = "/EFI/BOOT/BOOT${lib.toUpper config.nixpkgs.hostPlatform.efiArch}.EFI";
        };

        name = "appliance-verity-store-image";

        partitions = {
          ${partitionIds.esp} = {
            # the UKI is injected into this partition by the verityStore module
            repartConfig = {
              Type = "esp";
              Format = "vfat";
              SizeMinBytes = if config.nixpkgs.hostPlatform.isx86_64 then "64M" else "96M";
            };
          };
          ${partitionIds.store-verity}.repartConfig = {
            Minimize = "best";
          };
          ${partitionIds.store}.repartConfig = {
            Minimize = "best";
          };
        };
      };

      virtualisation = {
        directBoot.enable = false;
        mountHostNixStore = false;
        useEFIBoot = true;
      };

      boot = {
        loader.grub.enable = false;
        initrd.systemd.enable = true;
      };

      system.image = {
        id = "nixos-appliance";
        version = "1";
      };

      # don't create /usr/bin/env
      # this would require some extra work on read-only /usr
      # and it is not a strict necessity
      system.activationScripts.usrbinenv = lib.mkForce "";
    };

  testScript =
    { nodes, ... }: # python
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
        "${nodes.machine.system.build.finalImage}/${nodes.machine.image.repart.imageFile}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      machine.wait_for_unit("default.target")

      with subtest("Running with volatile root"):
        machine.succeed("findmnt --kernel --type tmpfs /")

      with subtest("/nix/store is backed by dm-verity protected fs"):
        verity_info = machine.succeed("dmsetup info --target verity usr")
        assert "ACTIVE" in verity_info,f"unexpected verity info: {verity_info}"

        backing_device = machine.succeed("df --output=source /nix/store | tail -n1").strip()
        assert "/dev/mapper/usr" == backing_device,"unexpected backing device: {backing_device}"
    '';
}
