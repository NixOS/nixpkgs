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
  name = "emacs-22.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/emacs/emacs-22.1.tar.gz;
    sha256 = "1l1y3il98pq3cz464p244wz2d3nga5lq8fkw5pwp5r97f7pkpi0y";
  };
  patches = [./crt.patch ./makefile-pwd.patch];
  buildInputs = [
    ncurses x11
    (if xawSupport then if xaw3dSupport then Xaw3d else libXaw else null)
    (if xpmSupport then libXpm else null)
  ] ++ (if gtkGUI then [pkgconfig gtk] else []);
  configureFlags =
    if gtkGUI then ["--with-x-toolkit=gtk"] else [];
}
