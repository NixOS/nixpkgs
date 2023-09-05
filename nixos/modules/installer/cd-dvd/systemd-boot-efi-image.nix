# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let
  efiArch = pkgs.stdenv.hostPlatform.efiArch;

  mkLoaderEntry = { title, version, linux ? null, initrd ? null, options ? null }@attrs:
  let
    usedAttrs = filterAttrs (_: value: value != null) attrs;
    mkItem = key: value:
      let value' =
        if key == "options" then lib.concatStringsSep " " value else value;
      in
      "${key} ${value'}";
    keyValueEntries = builtins.attrValues (mapAttrs mkItem usedAttrs);
  in
  lib.concatStringsSep "\n" keyValueEntries;

  mkNixOS = extraOptions:
  let
    title = "${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName}${config.isoImage.appendToMenuLabel}";
  in
  {
    inherit title;
    entry = mkLoaderEntry {
      inherit title;
      version = "${config.system.nixos.label}" + lib.optionalString (extraOptions != [ ]) " (${lib.concatStringsSep "," extraOptions})";
      linux = "/efi/nixos/${config.system.boot.loader.kernelFile}";
      initrd = "/efi/nixos/${config.system.boot.loader.initrdFile}";
      options = [
        "init=${config.system.build.toplevel}/init"
      ] ++ config.boot.kernelParams ++ extraOptions;
    };
  };

  nixosMenu = [
    (mkNixOS [ ])
    (mkNixOS [ "nomodeset" ])
    (mkNixOS [ "copytoram" ])
    (mkNixOS [ "debug" ])
  ];

  sdBootTimeout = if config.boot.loader.timeout == null then 0 else config.boot.loader.timeout;

  entries = lib.imap (index: item: pkgs.writeTextFile { name = "nixos-${toString index}.conf"; text = item.entry; }) nixosMenu;

  efiDir = pkgs.runCommand "efi-directory" {
    nativeBuildInputs = [ pkgs.coreutils ];
  } ''
    mkdir -p $out/EFI

    # Install kernel and initrd
    install -Dvm644 ${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile} $out/EFI/nixos/${config.system.boot.loader.kernelFile}
    install -Dvm644 ${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile} $out/EFI/nixos/${config.system.boot.loader.initrdFile}

    # Install systemd boot there.
    install -Dvm644 ${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi $out/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI

    # Install all BLS entries.
    ${lib.concatStringsSep "\n"
    (map (entry: "install -Dvm644 ${entry} $out/loader/entries/${entry.name}") entries)}

    # Install systemd boot configuration.
    cat > $out/loader/loader.conf <<EOF
    timeout ${toString sdBootTimeout}
    editor yes
    auto-entries no
    auto-firmware yes
    default nixos-1.conf
    EOF
  '';

  efiImg = pkgs.runCommand "efi-image_eltorito" {
    nativeBuildInputs = [ pkgs.buildPackages.mtools pkgs.buildPackages.libfaketime pkgs.buildPackages.dosfstools ];
    strictDeps = true;
  }
    # Be careful about determinism: du --apparent-size,
    #   dates (cp -p, touch, mcopy -m, faketime for label), IDs (mkfs.vfat -i)
    ''
      mkdir ./contents && cd ./contents
      mkdir -p ./EFI
      cp -rp "${efiDir}"/EFI/{nixos,BOOT} ./EFI/ && cp -rp "${efiDir}"/loader .

      # Rewrite dates for everything in the FS
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

      for d in $(find loader -type d | sort); do
        faketime "2000-01-01 00:00:00" mmd -i "$out" "::/$d"
      done


      for f in $(find EFI -type f | sort); do
        mcopy -pvm -i "$out" "$f" "::/$f"
      done

      for f in $(find loader -type f | sort); do
        mcopy -pvm -i "$out" "$f" "::/$f"
      done

      # Verify the FAT partition.
      fsck.vfat -vn "$out"
    ''; # */



in

{
  options.isoImage.systemd-boot = {
    enable = mkOption {
      default = config.isoImage.makeEfiBootable;
      type = lib.types.bool;
    };
  };
  config = mkIf config.isoImage.systemd-boot.enable {
    # Don't run the systemd-boot script here, we don't need it.
    boot.loader.systemd-boot.enable = false;
    boot.loader.grub.enable = false;
    boot.loader.timeout = lib.mkDefault 10;

    isoImage.contents = optionals config.isoImage.makeEfiBootable [
      { source = efiImg;
        target = "/boot/efi.img";
      }
      { source = "${efiDir}/EFI";
        target = "/EFI";
      }
    ];
  };

}
