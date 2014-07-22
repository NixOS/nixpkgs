/* A list of file names of package Nix expressions, whose base names
   match the intended attribute names, and that do not need to be
   called with any overrides. Thus, listing ‘./foo.nix’ here is
   equivalent to defining the attribute

     foo = callPackage ./foo.nix { };

   in all-packages.nix. */

[
  build-support/libredirect
  development/libraries/libogg
  development/libraries/libvorbis
  tools/archivers/gnutar
  tools/system/acct
]
