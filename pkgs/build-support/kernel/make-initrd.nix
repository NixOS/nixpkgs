# Create an initial ramdisk containing the closure of the specified
# file system objects.  An initial ramdisk is used during the initial
# stages of booting a Linux system.  It is loaded by the boot loader
# along with the kernel image.  It's supposed to contain everything
# (such as kernel modules) necessary to allow us to mount the root
# file system.  Once the root file system is mounted, the `real' boot
# script can be called.
#
# An initrd is really just a gzipped cpio archive.
#
# Symlinks are created for each top-level file system object.  E.g.,
# `contents = {object = ...; symlink = /init;}' is a typical
# argument.

{ stdenv, perl, cpio, contents, ubootTools
, name ? "initrd"
, compressor ? "gzip -9n"
, prepend ? []
, lib
}:
let 
  # !!! Move this into a public lib function, it is probably useful for others
  toValidStoreName = x: with builtins; 
    lib.concatStringsSep "-" (filter (x: !(isList x)) (split "[^a-zA-Z0-9_=.?-]+" x));

in stdenv.mkDerivation rec {
  inherit name;

  builder = ./make-initrd.sh;

  makeUInitrd = stdenv.hostPlatform.platform.kernelTarget == "uImage";

  nativeBuildInputs = [ perl cpio ]
    ++ stdenv.lib.optional makeUInitrd ubootTools;

  # !!! should use XML.
  objects = map (x: x.object) contents;
  symlinks = map (x: x.symlink) contents;
  suffices = map (x: if x ? suffix then x.suffix else "none") contents;

  # For obtaining the closure of `contents'.
  # Note: we don't use closureInfo yet, as that won't build with nix-1.x.
  # See #36268.
  exportReferencesGraph =
    lib.zipListsWith 
      (x: i: [("closure-${toValidStoreName (baseNameOf x.symlink)}-${toString i}") x.object]) 
      contents 
      (lib.range 0 (lib.length contents - 1));
  pathsFromGraph = ./paths-from-graph.pl;

  inherit compressor prepend;
}

