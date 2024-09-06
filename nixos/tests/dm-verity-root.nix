# Tests a NixOS system with a read-only root filesystem that's integrity-protected
# through DM-verity. The root filesystem is mounted read-only, and for NixOS activation
# to succeed, an overlay `tmpfs` is mounted on top of it.
# This test uses systemd-repart to create a bootable disk image, as it supplies handy
# utilities for creating verity partitions, but it can also be setup manually through
# `systemd-veritysetup`.

{ lib, pkgs, ... }:

let
  imageId = "verity-root-image";
  imageVersion = "1-rc1";

  # Use a random, but fixed root hash placeholder to allow us specifying the "real" root hash
  # after the image is first built.
  roothashPlaceholder = "61fe0f0c98eff2a595dd2f63a5e481a0a25387261fa9e34c37e3a4910edf32b8";
in
{
  name = "verity-root";

  meta.maintainers = with lib.maintainers; [ msanft ];

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      modulesPath,
      ...
    }:
    {

      imports = [ "${modulesPath}/image/repart.nix" ];

      virtualisation.directBoot.enable = false;
      virtualisation.mountHostNixStore = false;
      virtualisation.useEFIBoot = true;

      # Disable boot loaders, as a UKI is used, which contains systemd-stub.
      # TODO(raitobezarius): revisit this when #244907 lands
      boot.loader.grub.enable = false;

      system.image.id = imageId;
      system.image.version = imageVersion;

      # systemd-veritysetup-generator and systemd-fstab-generator take care of setting up the root filesystem.
      virtualisation.fileSystems = lib.mkForce {
        "/" = {
          device = "/dev/mapper/root";
          fsType = "erofs";
        };
        # TODO(msanft):
        # This should really be replaced with a tmpfs overlay on /sysroot,
        # but in the current implementation of `virtualisation.fileSystems.<name>.overlay,
        # the overlay upperdir and workdir is automatically prefixed with /sysroot
        # if `neededForBoot` is set to true.
        # Thus, we cannot mount a path from the initrd into the userspace.
        "/etc" = {
          neededForBoot = true;
          fsType = "tmpfs";
        };
        "/var" = {
          neededForBoot = true;
          fsType = "tmpfs";
        };
        "/run" = {
          neededForBoot = true;
          fsType = "tmpfs";
        };
        "/tmp" = {
          neededForBoot = true;
          fsType = "tmpfs";
        };
      };

      # Provides 'veritysetup' to check if the verity-protected device
      # has been mapped correctly.
      environment.systemPackages = with pkgs; [ cryptsetup ];

      boot.initrd = {
        kernelModules = [ "overlay" ];
        supportedFilesystems = [ "erofs" ];

        systemd = {
          enable = true;
          dmVerity.enable = true;
        };
      };

      boot.kernelParams = [
        "systemd.verity=yes"
        "roothash=${roothashPlaceholder}"
      ];

      image.repart = {
        name = imageId;
        # OVMF does not work with the default repart sector size of 4096
        sectorSize = 512;
        partitions = {
          # ESP
          "00-esp" = {
            contents =
              let
                efiArch = config.nixpkgs.hostPlatform.efiArch;
              in
              {
                "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

                "/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
              };
            repartConfig = {
              Type = "esp";
              Format = "vfat";
              # Minimize = "guess" seems to not work very well for vfat
              # partitions. It's better to set a sensible default instead. The
              # aarch64 kernel seems to generally be a little bigger than the
              # x86_64 kernel. To stay on the safe side, leave some more slack
              # for every platform other than x86_64.
              SizeMinBytes = if config.nixpkgs.hostPlatform.isx86_64 then "64M" else "96M";
            };
          };

          # Root Partition
          "10-root" = {
            storePaths = [ config.system.build.toplevel ];
            repartConfig = {
              Type = "root";
              Format = "erofs";
              Label = "root";
              Verity = "data";
              VerityMatchKey = "root";
              Minimize = "best";
              # We need to ensure that mountpoints are available.
              MakeDirectories = "/bin /boot /dev /etc /home /lib /lib64 /mnt /nix /opt /proc /root /run /srv /sys /tmp /usr /var";
            };
          };

          # Verity hashtree for the root partition
          "20-root-verity" = {
            repartConfig = {
              Type = "root-verity";
              Label = "root-verity";
              Verity = "hash";
              VerityMatchKey = "root";
              Minimize = "best";
            };
          };
        };
      };
    };

  testScript =
    let
      # We override the build of the image by extending it with code to replace the placeholder with the real root hash.
      # This way, we can build the image first and then set the root hash afterwards in a single derivation.
      # It would be a more elegant solution to have 2 derivations and call repart once with `--defer-partitions`, but that
      # comes at the cost of additional cost and storage space for the intermediate image, which is not benefitial for this test.
      buildOverride = oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.jq ];
        postInstall = ''
          # Replace the placeholder with the real root hash.
          realRoothash=$(${pkgs.jq}/bin/jq -r "[.[] | select(.roothash != null)] | .[0].roothash" $out/repart-output.json)
          sed -i "0,/${roothashPlaceholder}/ s/${roothashPlaceholder}/$realRoothash/" $out/${oldAttrs.pname}_${oldAttrs.version}.raw
        '';
      };
    in
    { nodes, ... }:
    ''
      import os, subprocess, tempfile

      tmp_disk_image = tempfile.NamedTemporaryFile()

      subprocess.run([
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
        "create",
        "-f",
        "qcow2",
        "-b",
        "${nodes.machine.system.build.image.overrideAttrs buildOverride}/${nodes.machine.image.repart.imageFile}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      verity_status = machine.succeed("veritysetup status root")
      assert "type:        VERITY" in verity_status
      assert "status:      verified" in verity_status

      commandline = machine.succeed("cat /proc/cmdline")
      roothash = commandline.split("roothash=")[1].split(" ")[0]
      assert roothash in verity_status
    '';
}
