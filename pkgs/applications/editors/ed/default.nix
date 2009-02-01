{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ed-1.2";
  src = fetchurl {
    url = "mirror://gnu/ed/${name}.tar.gz";
    sha256 = "1jhw050fzaffjf5qdj1ccn7alngam7yhd5zpzyxvrjphwmkd46kx";
  };

  doCheck = true;

  meta = {
    description = "GNU ed, an implementation of the standard Unix editor";

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

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/ed/;
  };
}
