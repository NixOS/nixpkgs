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

stdenv.mkDerivation {
  name = "emacs-22.2";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://gnu/emacs/emacs-22.2.tar.gz;
    md5 = "d6ee586b8752351334ebf072904c4d51";
  };
  
  buildInputs = [ncurses x11]
    ++ stdenv.lib.optional xawSupport (if xaw3dSupport then Xaw3d else libXaw)
    ++ stdenv.lib.optional xpmSupport libXpm
    ++ stdenv.lib.optionals gtkGUI [pkgconfig gtk];
  
  configureFlags =
    stdenv.lib.optional gtkGUI "--with-x-toolkit=gtk";

  meta = {
    description = "Emacs, *the* text editor";
    homepage = http://www.gnu.org/software/emacs/;
    license = "GPL";
  };
}
