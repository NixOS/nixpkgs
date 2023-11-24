# Tests building and running a GUID Partition Table (GPT) appliance image.
# "Appliance" here means that the image does not contain the normal NixOS
# infrastructure of a system profile and cannot be re-built via
# `nixos-rebuild`.

{ lib, ... }:

let
  rootPartitionLabel = "root";

  bootLoaderConfigPath = "/loader/entries/nixos.conf";
  kernelPath = "/EFI/nixos/kernel.efi";
  initrdPath = "/EFI/nixos/initrd.efi";
in
{
  name = "appliance-gpt-image";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = { config, lib, pkgs, ... }: {

    imports = [ ../modules/image/repart.nix ];

    virtualisation.directBoot.enable = false;
    virtualisation.mountHostNixStore = false;
    virtualisation.useEFIBoot = true;

    # Disable boot loaders because we install one "manually".
    # TODO(raitobezarius): revisit this when #244907 lands
    boot.loader.grub.enable = false;

    virtualisation.fileSystems = lib.mkForce {
      "/" = {
        device = "/dev/disk/by-partlabel/${rootPartitionLabel}";
        fsType = "ext4";
      };
    };

    image.repart = {
      name = "appliance-gpt-image";
      partitions = {
        "esp" = {
          contents =
            let
              efiArch = config.nixpkgs.hostPlatform.efiArch;
            in
            {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

              # TODO: create an abstraction for Boot Loader Specification (BLS) entries.
              "${bootLoaderConfigPath}".source = pkgs.writeText "nixos.conf" ''
                title NixOS
                linux ${kernelPath}
                initrd ${initrdPath}
                options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
              '';

              "${kernelPath}".source =
                "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";

              "${initrdPath}".source =
                "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
            };
          repartConfig = {
            Type = "esp";
            Format = "vfat";
            # Minimize = "guess" seems to not work very vell for vfat
            # partitons. It's better to set a sensible default instead. The
            # aarch64 kernel seems to generally be a little bigger than the
            # x86_64 kernel. To stay on the safe side, leave some more slack
            # for every platform other than x86_64.
            SizeMinBytes = if config.nixpkgs.hostPlatform.isx86_64 then "64M" else "96M";
          };
        };
        "root" = {
          storePaths = [ config.system.build.toplevel ];
          repartConfig = {
            Type = "root";
            Format = config.fileSystems."/".fsType;
            Label = rootPartitionLabel;
            Minimize = "guess";
          };
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
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
      "${nodes.machine.system.build.image}/image.raw",
      "-F",
      "raw",
      tmp_disk_image.name,
    ])

    # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
    os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

    bootctl_status = machine.succeed("bootctl status")
    assert "${bootLoaderConfigPath}" in bootctl_status
    assert "${kernelPath}" in bootctl_status
    assert "${initrdPath}" in bootctl_status
  '';
}
