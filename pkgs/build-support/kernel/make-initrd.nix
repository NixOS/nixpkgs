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

{stdenv, perl, cpio, contents, ubootChooser}:

let
  inputsFun = ubootName : [perl cpio]
    ++ stdenv.lib.optional (ubootName != null) [ (ubootChooser ubootName) ];
  makeUInitrdFun = ubootName : (ubootName != null);
in
stdenv.mkDerivation {
  name = "initrd";
  builder = ./make-initrd.sh;
  nativeBuildInputs = inputsFun stdenv.platform.uboot;

  makeUInitrd = makeUInitrdFun stdenv.platform.uboot;

  # !!! should use XML.
  objects = map (x: x.object) contents;
  symlinks = map (x: x.symlink) contents;
  suffices = map (x: if x ? suffix then x.suffix else "none") contents;
  
  # For obtaining the closure of `contents'.
  exportReferencesGraph =
    map (x: [("closure-" + baseNameOf x.symlink) x.object]) contents;
  pathsFromGraph = ./paths-from-graph.pl;

  crossAttrs = {
    nativeBuildInputs = inputsFun stdenv.cross.platform.uboot;
    makeUInitrd = makeUInitrdFun stdenv.cross.platform.uboot;
  };
}
