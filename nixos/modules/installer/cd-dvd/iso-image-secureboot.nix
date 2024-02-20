# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let
  targetArch =
    if config.boot.loader.grub.forcei686 then
      "ia32"
    else
      pkgs.stdenv.hostPlatform.efiArch;

  uki = pkgs.runCommand "uki" { } ''
    mkdir $out
    hash=$(sha256sum ${config.system.build.squashfsStore} | cut -d ' ' -f 1)
    args=(
      build
      --output $out/uki.efi
      --linux ${config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile}
      --initrd ${config.system.build.initialRamdisk + "/" + config.system.boot.loader.initrdFile}
      --cmdline init=${config.system.build.toplevel}/init\ ${escapeShellArg (toString config.boot.kernelParams)}\ store_squashfs_hash=$hash
      --os-release ${config.system.build.etc}/os-release
      --stub ${pkgs.systemd}/lib/systemd/boot/efi/linux${targetArch}.efi.stub
      --sbat ${config.boot.secureboot.sbat}
    )
    ${pkgs.buildPackages.ukify}/lib/systemd/ukify "''${args[@]}"
  '';

  grubConfig = pkgs.writeTextFile {
    name = "grub.cfg";
    checkPhase = ''
      ${pkgs.buildPackages.grub2_efi}/bin/grub-script-check $target
    '';
    text = ''
      set timeout=${toString config.boot.loader.timeout}

      clear
      echo ""
      echo "Loading graphical boot menu..."
      echo ""
      echo "Press 't' to use the text boot menu on this console..."
      echo ""

      insmod gfxterm
      set gfxpayload=keep

      menuentry 'NixOS installer' {
        chainloader /EFI/boot/uki.efi
      }
      menuentry 'Firmware Setup' --class settings {
        fwsetup
        clear
        echo ""
        echo "If you see this message, your EFI system doesn't support this feature."
        echo ""
      }
      menuentry 'Next EFI boot entry' {
        exit
      }
      menuentry 'Shutdown' --class shutdown {
        halt
      }
    '';
  };

  grubImage = pkgs.runCommand "grub.img"
    {
      nativeBuildInputs = [ pkgs.buildPackages.grub2_efi ];
      strictDeps = true;
      __structuredAttrs = true;
      modules = [
        "fat"
        "iso9660"
        "part_gpt"
        "part_msdos"

        "normal"
        "boot"
        "configfile"
        "loopback"
        "chain"
        "halt"

        "efifwsetup"

        "minicmd"

        "efi_gop"

        "ls"
        "cat"

        "search"
        "search_label"
        "search_fs_uuid"
        "search_fs_file"
        "echo"

        "serial"

        "gfxmenu"
        "gfxterm"
        "gfxterm_background"
        "gfxterm_menu"
        "test"
        "loadenv"
        "all_video"
        "videoinfo"

        "png"

        "efi_uga"
      ];
    } ''
    mkdir -p $out
    grub-mkimage \
      --sbat=${config.boot.secureboot.sbat} \
      --directory=${pkgs.grub2_efi}/lib/grub/${pkgs.grub2_efi.grubTarget} \
      -o $out/grub.efi \
      -p /EFI/boot \
      -O ${pkgs.grub2_efi.grubTarget} \
      ''${modules[@]}
  '';

  efiDir = (pkgs.linkFarm "efi-dir" {
    "EFI/boot/boot${targetArch}.efi" = config.boot.secureboot.shim;
    "EFI/boot/grub${targetArch}.efi" = config.boot.secureboot.signFile (grubImage + "/grub.efi");
    "EFI/boot/uki.efi" = config.boot.secureboot.signFile (uki + "/uki.efi");
    "EFI/nixos-installer-image" = builtins.toFile "marker" "";
    "EFI/boot/grub.cfg" = grubConfig;
  }).overrideAttrs (o: {
    buildCommand = o.buildCommand + ''
      cd -
      mv $out tmp
      cp -r --dereference tmp $out
    '';
  });

  efiImage = pkgs.runCommand "efi-image_eltorito"
    {
      nativeBuildInputs = [ pkgs.buildPackages.mtools pkgs.buildPackages.libfaketime pkgs.buildPackages.dosfstools ];
      strictDeps = true;
    }
    # Be careful about determinism: du --apparent-size,
    #   dates (cp -p, touch, mcopy -m, faketime for label), IDs (mkfs.vfat -i)
    ''
      mkdir contents && cd contents
      cp -rp --dereference "${efiDir}/EFI" ./EFI
      find . -exec touch --date=2000-01-01 {} +

      # Round up to the nearest multiple of 1MB, for more deterministic du output
      usage_size=$(( $(du -s --block-size=1M --apparent-size . | tr -cd '[:digit:]') * 1024 * 1024 ))
      # Make the image 110% as big as the files need to make up for FAT overhead
      image_size=$(( ($usage_size * 110) / 100 ))
      # Make the image fit blocks of 1M
      block_size=$((1024*1024))
      image_size=$(( ($image_size / $block_size + 1) * $block_size ))
      echo "Usage size: $usage_size"
      echo "Image size: $image_size"
      truncate --size=$image_size "$out"
      mkfs.vfat --invariant -i 12345678 -n EFIBOOT "$out"

      # Force a fixed order in mcopy for better determinism, and avoid file globbing
      for d in $(find EFI -type d | sort); do
        faketime "2000-01-01 00:00:00" mmd -i "$out" "::/$d"
      done

      for f in $(find EFI -type f | sort); do
        mcopy -pvm -i "$out" "$f" "::/$f"
      done

      # Verify the FAT partition.
      fsck.vfat -vn "$out"
    '';

in

{
  config = {

    boot.initrd.systemd.enable = true;

    boot.initrd.systemd.mounts = [
      {
        where = "/sysroot";
        what = "tmpfs";
        wantedBy = ["initrd-fs.target"];
        mountConfig = {
          Type = "tmpfs";
          Options = [ "mode=0755" ];
        };
      }
      {
        where = "/run/iso";
        what = "/dev/disk/by-label/${config.isoImage.volumeID}";
        mountConfig = {
          Type = "iso9660";
        };
      }
    ];
    boot.initrd.systemd.services.verify-squashfs = {
      requiredBy = [ "run-nix-.ro\\x2dstore.mount" ];
      before = [ "run-nix-.ro\\x2dstore.mount" ];
      requires = [ "run-iso.mount" ];
      after = [ "run-iso.mount" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "kmsg+console";
        RemainAfterExit = true;
      };
      script = ''
        set -x
        </proc/cmdline readarray -d ' ' params
        for param in "''${params[@]}"; do
          [[ $param = store_squashfs_hash=* ]] || continue
          hash="''${param#store_squashfs_hash=}"
          hash="''${hash%$'\n'}"
        done
        if [[ -z "$hash" ]]; then
          echo "Could not find expected Nix store squashfs hash on command line."
          false
        fi
        sha256sum -c <<EOF
        $hash ${config.fileSystems."/nix/.ro-store".device}
        EOF
      '';
    };
    # overlayfs requires the mutable directories, but
    # won't create them by itself.
    boot.initrd.systemd.services.mkdir-rw-store = {
      description = "Store Overlay Mutable Directories";
      requiredBy = [ "sysroot-nix-store.mount" ];
      before = [ "sysroot-nix-store.mount" ];
      unitConfig.RequiresMountsFor = "/nix/.rw-store";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        mkdir -p /nix/.rw-store/{work,store}
      '';
    };

    boot.loader.grub.enable = false;

    lib.isoFileSystems = mkImageMediaOverride {
      "/" = mkImageMediaOverride
        {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
        };

      "/run/iso" = mkImageMediaOverride
        {
          label = config.isoImage.volumeID;
          fsType = "auto";
          neededForBoot = true;
          noCheck = true;
        };

      # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
      # image) to make this a live CD.
      "/nix/.ro-store" = mkImageMediaOverride
        {
          fsType = "squashfs";
          device = "/run/iso/nix-store.squashfs";
          options = [ "loop" ];
          neededForBoot = true;
          depends = ["/run/iso"];
        };

      "/nix/.rw-store" = mkImageMediaOverride
        {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
          neededForBoot = true;
        };

      "/nix/store" = mkImageMediaOverride
        {
          overlay = {
            lowerdir = ["/nix/.ro-store"];
            upperdir = "/nix/.rw-store/store";
            workdir = "/nix/.rw-store/work";
          };
          neededForBoot = true;
        };

    };

    isoImage.efiBootImage = config.boot.secureboot.signFile config.boot.secureboot.shim;
    isoImage = {
      includeRefind = false;
      makeBiosBootable = false;
      makeEfiBootable = true;
      makeUsbBootable = true;
    };

    system.build.isoImage = lib.mkForce (pkgs.callPackage ../../../lib/make-iso9660-image.nix {
      inherit (config.isoImage) isoName compressImage volumeID;
      contents = [
        { source = efiImage;
          target = "/boot/efi.img";
        }
        { source = config.system.build.squashfsStore;
          target = "/nix-store.squashfs";
        }
        { source = efiDir + "/EFI";
          target = "/EFI";
        }
      ];
      efiBootable = true;
      efiBootImage = "boot/efi.img";
    });
  };
}
