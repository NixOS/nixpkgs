{ stdenv, perl, pathsFromGraph, xorriso, syslinux

, # The file name of the resulting ISO image.
  isoName ? "cd.iso"

, # The files and directories to be placed in the ISO file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

, # In addition to `contents', the closure of the store paths listed
  # in `packages' are also placed in the Nix store of the CD.  This is
  # a list of attribute sets {object, symlink} where `object' if a
  # store path whose closure will be copied, and `symlink' is a
  # symlink to `object' that will be added to the CD.
  storeContents ? []

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

, # Whether to compress the resulting ISO image with bzip2.
  compressImage ? false

, # The volume ID.
  volumeID ? ""
}:

assert bootable -> bootImage != "";
assert efiBootable -> efiBootImage != "";
assert usbBootable -> isohybridMbrImage != "";

stdenv.mkDerivation {
  name = isoName;
  builder = ./make-iso9660-image.sh;
  buildInputs = [perl xorriso syslinux];

  inherit isoName bootable bootImage compressImage volumeID pathsFromGraph efiBootImage efiBootable isohybridMbrImage usbBootable;

  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  # !!! should use XML.
  objects = map (x: x.object) storeContents;
  symlinks = map (x: x.symlink) storeContents;

  # For obtaining the closure of `storeContents'.
  exportReferencesGraph =
    map (x: [("closure-" + baseNameOf x.object) x.object]) storeContents;
}
