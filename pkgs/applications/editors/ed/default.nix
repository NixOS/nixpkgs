{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ed-1.13";

  src = fetchurl {
    # gnu only provides *.lz tarball, which is unfriendly for stdenv bootstrapping
    #url = "mirror://gnu/ed/${name}.tar.gz";
    # When updating, please make sure the sources pulled match those upstream by
    # Unpacking both tarballs and running `find . -type f -exec sha256sum \{\} \; | sha256sum`
    # in the resulting directory
    url = "http://fossies.org/linux/privat/${name}.tar.bz2";
    sha256 = "1iym2fsamxr886l3sz8lqzgf00bip5cr0aly8jp04f89kf5mvl0j";
  };

  /* FIXME: Tests currently fail on Darwin:

       building test scripts for ed-1.5...
       testing ed-1.5...
       *** Output e1.o of script e1.ed is incorrect ***
       *** Output r3.o of script r3.ed is incorrect ***
       make: *** [check] Error 127

    */
  doCheck = !stdenv.isDarwin;

  crossAttrs = {
    compileFlags = [ "CC=${stdenv.cross.config}-gcc" ];
  };

  meta = {
    description = "An implementation of the standard Unix editor";

    longDescription = ''
      GNU ed is a line-oriented text editor.  It is used to create,
      display, modify and otherwise manipulate text files, both
      interactively and via shell scripts.  A restricted version of ed,
      red, can only edit files in the current directory and cannot
      execute shell commands.  Ed is the "standard" text editor in the
      sense that it is the original editor for Unix, and thus widely
      available.  For most purposes, however, it is superseded by
      full-screen editors such as GNU Emacs or GNU Moe.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/ed/;

    maintainers = [ ];
  };
}
