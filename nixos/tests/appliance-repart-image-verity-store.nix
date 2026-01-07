# similar to the appliance-repart-image test but with a dm-verity
# protected nix store and tmpfs as rootfs
{ lib, ... }:

{
  name = "appliance-repart-image-verity-store";

  meta.maintainers = with lib.maintainers; [
    nikstur
    willibutz
  ];

  defaults =
    { config, lib, ... }:
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

        # bind-mount the store
        "/nix/store" = {
          device = "/usr/nix/store";
          fsType = "none";
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

      system.image.id = "nixos-appliance";

      # don't create /usr/bin/env
      # this would require some extra work on read-only /usr
      # and it is not a strict necessity
      system.activationScripts.usrbinenv = lib.mkForce "";
    };

  nodes.machine = {
    system.image.version = "1";
  };

  nodes.without-version = { };

  testScript =
    { nodes, ... }: # python
    ''
      import os
      import subprocess
      import tempfile

      def create_disk_image(qemu_img, backing_file):
        tmp = tempfile.NamedTemporaryFile()
        subprocess.run([
          qemu_img,
          "create",
          "-f",
          "qcow2",
          "-b",
          backing_file,
          "-F",
          "raw",
          tmp.name,
        ], check=True)
        return tmp

      def run_verity_tests(machine):
        with subtest("Running with volatile root"):
          machine.succeed("findmnt --kernel --type tmpfs /")

        with subtest("/nix/store is backed by dm-verity protected fs"):
          verity_info = machine.succeed("dmsetup info --target verity usr")
          assert "ACTIVE" in verity_info, f"unexpected verity info: {verity_info}"

          backing_device = machine.succeed("df --output=source /nix/store | tail -n1").strip()
          assert "/dev/mapper/usr" == backing_device, f"unexpected backing device: {backing_device}"

      tmp_disk_machine = create_disk_image(
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
        "${nodes.machine.system.build.image}/${nodes.machine.image.filePath}",
      )
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_machine.name
      machine.wait_for_unit("default.target")
      run_verity_tests(machine)
      with subtest("Image version is set"):
        machine.succeed("grep IMAGE_VERSION=1 /etc/os-release")

      tmp_disk_without_version = create_disk_image(
        "${nodes."without-version".virtualisation.qemu.package}/bin/qemu-img",
        "${nodes."without-version".system.build.image}/${nodes."without-version".image.filePath}",
      )
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_without_version.name
      without_version.wait_for_unit("default.target")
      run_verity_tests(without_version)
      with subtest("Image version is not set"):
        without_version.succeed('grep IMAGE_VERSION="" /etc/os-release')
    '';
}
