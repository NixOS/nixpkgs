{ stdenv, cdrtools

  # The file name of the resulting ISO image.
, isoName ? "cd.iso"

, # The files and directories to be placed in the ISO file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

, # In addition to `contents', the closure of the store paths listed
  # in `packages' are also placed in the Nix store of the CD.  This is
  # a list of attribute sets {source, target} where `source' if a
  # store path whose closure will be copied, and `target' is a symlink
  # to `source' that will be added to the CD.
  storeContents ? []

  # Whether this should be an El-Torito bootable CD.
, bootable ? false

  # The path (in the ISO file system) of the boot image.
, bootImage ? ""

}:

assert bootable -> bootImage != "";

stdenv.mkDerivation {
  name = "iso9660-image";
  builder = ./make-iso9660-image.sh;
  buildInputs = [cdrtools];
  inherit isoName bootable bootImage;

  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  # !!! should use XML.
  objects = map (x: x.object) storeContents;
  symlinks = map (x: x.symlink) storeContents;
  
  # For obtaining the closure of `storeContents'.
  exportReferencesGraph =
    map (x: [("closure-" + baseNameOf x.symlink) x.object]) storeContents;
  pathsFromGraph = ./paths-from-graph.sh;
}
