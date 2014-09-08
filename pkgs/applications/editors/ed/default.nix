{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ed-1.10";

  src = fetchurl {
    # gnu only provides *.lz tarball, which is unfriendly for stdenv bootstrapping
    #url = "mirror://gnu/ed/${name}.tar.gz";
    url = "http://pkgs.fedoraproject.org/repo/extras/ed/${name}.tar.bz2"
      + "/38204d4c690a17a989e802ba01b45e98/${name}.tar.bz2";
    sha256 = "16qvshl8470f3znjfrrci3lzllqkzc6disk5kygzsg9hh4f6wysq";
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
