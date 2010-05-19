{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, stdenv, fetchurl, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null
, ncurses
}:

assert xawSupport && !xaw3dSupport -> libXaw != null;
assert xawSupport && xaw3dSupport -> Xaw3d != null;
assert xpmSupport -> libXpm != null;
assert gtkGUI -> pkgconfig != null && gtk != null;

stdenv.mkDerivation rec {
  name = "emacs-22.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.gz";
    sha256 = "05hd89bchcpwzcx5la0alcp0wb7xywvnf98dxrshrqlfvccvgnbv";
  };

  buildInputs = [ncurses x11]
    ++ stdenv.lib.optional xawSupport (if xaw3dSupport then Xaw3d else libXaw)
    ++ stdenv.lib.optional xpmSupport libXpm
    ++ stdenv.lib.optionals gtkGUI [pkgconfig gtk];

  configureFlags =
    stdenv.lib.optional gtkGUI "--with-x-toolkit=gtk";

  meta = {
    description = "GNU Emacs, *the* text editor";

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.
      At its core is an interpreter for Emacs Lisp, a dialect of the
      Lisp programming language with extensions to support text
      editing.
    '';

    homepage = http://www.gnu.org/software/emacs/;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
