# Tests a NixOS system with a read-only root filesystem that's integrity-protected
# through DM-verity. The root filesystem is mounted read-only, and for NixOS activation
# to suceed, an overlay tmpfs is mounted on top of it.
# This test uses systemd-repart to create a bootable disk image, as it supplies handy
# utilities for creating verity partitions, but it can also be setup manually through
# `systemd-veritysetup`.

{ lib, pkgs, ... }:

let
  rootPartitionLabel = "root";
  imageId = "verity-root-image";
  imageVersion = "1-rc1";

  # Use a random, but fixed root hash placeholder to allow us specifying the "real" root hash
  # after the image is first built.
  roothashPlaceholder = "61fe0f0c98eff2a595dd2f63a5e481a0a25387261fa9e34c37e3a4910edf32b8";
in
{
  name = "verity-root";

  meta.maintainers = with lib.maintainers; [ msanft ];

  nodes.machine = { config, lib, pkgs, ... }: {

    imports = [ ../modules/image/repart.nix ];

    virtualisation.directBoot.enable = false;
    virtualisation.mountHostNixStore = false;
    virtualisation.useEFIBoot = true;

    # Disable boot loaders, as a UKI is used, which contains systemd-stub.
    # TODO(raitobezarius): revisit this when #244907 lands
    boot.loader.grub.enable = false;

    system.image.id = imageId;
    system.image.version = imageVersion;

    # Override defaults from the test harness.
    # Normally, users won't need to do this, as the option defaults to an empty attrset.
    fileSystems = lib.mkForce { };
    virtualisation.fileSystems = lib.mkForce { };

    # Provides 'veritysetup' to check if the verity-protected device
    # has been mapped correctly.
    environment.systemPackages = with pkgs; [ cryptsetup ];

    boot.initrd = {
      kernelModules = [ "overlay" ];
      supportedFilesystems = [ "erofs" ];

      # This adds some udev rules that are required for dm-verity to work.
      services.lvm.enable = true;

      systemd = {
        enable = true;

        root = "verity";
        verityRootHash = roothashPlaceholder;

        # We manually supply the config for systemd-tmpfiles, as the NixOS module doesn't
        # support tmpfiles config in the initrd, but the service is running anyways.
        contents."/etc/tmpfiles.d/mountpoints.conf".text = ''
          d /run/etc 0755 root root -
          d /run/etc/upper 0755 root root -
          d /run/etc/work 0755 root root -
          d /run/var 0755 root root -
          d /run/var/upper 0755 root root -
          d /run/var/work 0755 root root -
          d /run/tmp 0755 root root -
          d /run/tmp/upper 0755 root root -
          d /run/tmp/work 0755 root root -
        '';

        # We directly define the mount units here, as we need to specify dependencies very
        # granularly, and systemd-fstab-generator doesn't give us that flexibility.
        mounts = [
          {
            where = "/sysroot/etc";
            what = "overlay";
            type = "overlay";
            options = "lowerdir=/sysroot${config.system.build.etc}/etc,upperdir=/run/etc/upper,workdir=/run/etc/work";
            wantedBy = [ "initrd-fs.target" "initrd-switch-root.target" "default.target" ];
            before = [ "initrd-fs.target" ];
            after = [ "systemd-tmpfiles-setup.service" ];
            unitConfig.RequiresMountsFor = "/sysroot/nix/store";
            unitConfig.DefaultDependencies = false;
          }
          {
            where = "/sysroot/var";
            what = "overlay";
            type = "overlay";
            options = "lowerdir=/sysroot/var,upperdir=/run/var/upper,workdir=/run/var/work";
            wantedBy = [ "initrd-fs.target" "initrd-switch-root.target" "default.target" ];
            before = [ "initrd-fs.target" ];
            after = [ "systemd-tmpfiles-setup.service" ];
            unitConfig.RequiresMountsFor = "/sysroot/nix/store";
            unitConfig.DefaultDependencies = false;
          }
          {
            where = "/sysroot/tmp";
            what = "overlay";
            type = "overlay";
            options = "lowerdir=/sysroot/tmp,upperdir=/run/tmp/upper,workdir=/run/tmp/work";
            wantedBy = [ "initrd-fs.target" "initrd-switch-root.target" "default.target" ];
            before = [ "initrd-fs.target" ];
            after = [ "systemd-tmpfiles-setup.service" ];
            unitConfig.RequiresMountsFor = "/sysroot/nix/store";
            unitConfig.DefaultDependencies = false;
          }
        ];
      };
    };

    # boot.kernelParams = [ "systemd.log_level=debug" ];

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
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

              "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
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
      buildOverride = oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.jq ];
        postInstall = ''
          # Replace the placeholder with the real root hash.
          realRoothash=$(${pkgs.jq}/bin/jq -r "[.[] | select(.roothash != null)] | .[0].roothash" $out/repart-output.json)
          sed -i "0,/${roothashPlaceholder}/ s/${roothashPlaceholder}/$realRoothash/" $out/${oldAttrs.pname}_${oldAttrs.version}.raw
        '';
      };
    in
    { nodes, ... }: ''
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
        "${nodes.machine.system.build.image.overrideAttrs (buildOverride)}/${nodes.machine.image.repart.imageFile}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      os_release = machine.succeed("cat /etc/os-release")
      assert 'IMAGE_ID="${imageId}"' in os_release
      assert 'IMAGE_VERSION="${imageVersion}"' in os_release

      bootctl_status = machine.succeed("bootctl status")
      assert "Boot Loader Specification Type #2 (.efi)" in bootctl_status

      verity_status = machine.succeed("veritysetup status root")
      assert "type:        VERITY" in verity_status
      assert "status:      verified" in verity_status

      commandline = machine.succeed("cat /proc/cmdline")
      roothash = commandline.split("roothash=")[1].split(" ")[0]
      assert roothash in verity_status
    '';
}
