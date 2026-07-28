# Tests a bashless image. The forbiddenDependenciesRegexes from the bashless
# profile ensures that the closure doesn't contain any bash.

{ lib, ... }:

let
  storePartitionLabel = "root";
in
{

  name = "activation-bashless-image";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    {
      config,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        "${modulesPath}/image/repart.nix"
        "${modulesPath}/profiles/bashless.nix"
      ];

      # Backdoor uses bash
      testing.backdoor = false;

      virtualisation = {
        directBoot.enable = false;
        mountHostNixStore = false;
        useEFIBoot = true;
      };

      boot.loader.grub.enable = false;

      virtualisation.fileSystems = lib.mkForce {
        "/" = {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
        };

        "/nix/store" = {
          device = "/dev/disk/by-partlabel/${storePartitionLabel}";
          fsType = "erofs"; # Saves ~250MiB over ext4
        };
      };

      image.repart = {
        name = "bashless-image";
        mkfsOptions = {
          erofs = [ "-z lz4" ]; # Saves ~150MiB over no compression
        };
        partitions = {
          "esp" = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper config.nixpkgs.hostPlatform.efiArch}.EFI".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
            };
            repartConfig = {
              Type = "esp";
              Format = "vfat";
              SizeMinBytes = if config.nixpkgs.hostPlatform.isx86_64 then "64M" else "96M";
            };
          };
          "root" = {
            storePaths = [ config.system.build.toplevel ];
            nixStorePrefix = "/";
            repartConfig = {
              Type = "linux-generic";
              Format = config.fileSystems."/nix/store".fsType;
              Label = storePartitionLabel;
              Minimize = "best";
            };
          };
        };
      };
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
        "${nodes.machine.system.build.image}/${nodes.machine.image.fileName}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      machine.start()
      machine.wait_for_console_text("Startup finished.")
    '';
}
