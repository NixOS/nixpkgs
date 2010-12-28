{ stdenv, perl, xz, pathsFromGraph

, # The file name of the resulting tarball
  fileName ? "nixos-system-${stdenv.system}"

, # The files and directories to be placed in the tarball.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents

, # In addition to `contents', the closure of the store paths listed
  # in `packages' are also placed in the Nix store of the tarball.  This is
  # a list of attribute sets {object, symlink} where `object' if a
  # store path whose closure will be copied, and `symlink' is a
  # symlink to `object' that will be added to the tarball.
  storeContents ? []
}:

stdenv.mkDerivation {
  name = "tarball";
  builder = ./make-system-tarball.sh;
  buildInputs = [perl xz];
  
  inherit fileName pathsFromGraph;

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
