{ lib, stdenv, callPackage, closureInfo, xorriso, syslinux, libossp_uuid, squashfsTools

, # The file name of the resulting ISO image.
  isoName ? "cd.iso"

, # The files and directories to be placed in the ISO file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

, # In addition to `contents', the closure of the store paths listed
  # in `storeContents' are also placed in the Nix store of the CD.
  # This is a list of attribute sets {object, symlink} where `object'
  # is a store path whose closure will be copied, and `symlink' is a
  # symlink to `object' that will be added to the CD.
  storeContents ? []

, # In addition to `contents', the closure of the store paths listed
  # in `squashfsContents' is compressed as squashfs and the result is
  # placed in /nix-store.squashfs on the CD.
  # FIXME: This is a performance optimization to avoid Hydra copying
  # the squashfs between builders and should be removed when Hydra
  # is smarter about scheduling.
  squashfsContents ? []

, # Compression settings for squashfs
  squashfsCompression ? "xz -Xdict-size 100%"

, # Whether this should be an El-Torito bootable CD.
  bootable ? false

, # Whether this should be an efi-bootable El-Torito CD.
  efiBootable ? false

, # Whether this should be an hybrid CD (bootable from USB as well as CD).
  usbBootable ? false

, # The path (in the ISO file system) of the boot image.
  bootImage ? ""

, # The path (in the ISO file system) of the efi boot image.
  efiBootImage ? ""

, # The path (outside the ISO file system) of the isohybrid-mbr image.
  isohybridMbrImage ? ""

, # Whether to compress the resulting ISO image with zstd.
  compressImage ? false, zstd

, # The volume ID.
  volumeID ? ""
}:

assert bootable -> bootImage != "";
assert efiBootable -> efiBootImage != "";
assert usbBootable -> isohybridMbrImage != "";

let
  needSquashfs = squashfsContents != [];
  makeSquashfsDrv = callPackage ./make-squashfs.nix {
    storeContents = squashfsContents;
    comp = squashfsCompression;
  };
in
stdenv.mkDerivation {
  name = isoName;
  __structuredAttrs = true;

  buildCommandPath = ./make-iso9660-image.sh;
  nativeBuildInputs = [ xorriso syslinux zstd libossp_uuid ]
    ++ lib.optionals needSquashfs makeSquashfsDrv.nativeBuildInputs;

  inherit isoName bootable bootImage compressImage volumeID efiBootImage efiBootable isohybridMbrImage usbBootable;

  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  objects = map (x: x.object) storeContents;
  symlinks = map (x: x.symlink) storeContents;

  squashfsCommand = lib.optionalString needSquashfs makeSquashfsDrv.buildCommand;

  # For obtaining the closure of `storeContents'.
  closureInfo = closureInfo { rootPaths = map (x: x.object) storeContents; };
}
