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

{ stdenvNoCC, closureInfo, cpio, contents, ubootTools, jq
, name ? "initrd"
, compressor ? "gzip -9n"
, prepend ? []
, lib
}:
let
  # !!! Move this into a public lib function, it is probably useful for others
  toValidStoreName = x: with builtins;
    lib.concatStringsSep "-" (filter (x: !(isList x)) (split "[^a-zA-Z0-9_=.?-]+" x));

in stdenvNoCC.mkDerivation rec {
  inherit name;

  buildCommand = builtins.readFile ./make-initrd.sh;

  makeUInitrd = stdenvNoCC.hostPlatform.platform.kernelTarget == "uImage";

  nativeBuildInputs = [ cpio jq ]
    ++ stdenvNoCC.lib.optional makeUInitrd ubootTools;

  inherit contents;

  env.closure = "${closureInfo { rootPaths = map (x: x.object) contents; }}";

  inherit compressor prepend;
}
