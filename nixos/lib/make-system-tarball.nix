{ stdenv, closureInfo, pixz

, # The file name of the resulting tarball
  fileName ? "nixos-system-${stdenv.hostPlatform.system}"

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

  # Extra commands to be executed before archiving files
, extraCommands ? ""

  # Extra tar arguments
, extraArgs ? ""
  # Command used for compression
, compressCommand ? "pixz"
  # Extension for the compressed tarball
, compressionExtension ? ".xz"
  # extra inputs, like the compressor to use
, extraInputs ? [ pixz ]
}:

let
  symlinks = map (x: x.symlink) storeContents;
  objects = map (x: x.object) storeContents;
in

stdenv.mkDerivation {
  name = "tarball";
  builder = ./make-system-tarball.sh;
  buildInputs = extraInputs;

  inherit fileName extraArgs extraCommands compressCommand;

  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  # !!! should use XML.
  inherit symlinks objects;

  closureInfo = closureInfo {
    rootPaths = objects;
  };

  extension = compressionExtension;
}
