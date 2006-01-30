{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchurl, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null, libpng ? null
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

stdenv.mkDerivation {
  name = "emacs-22.0.50-pre-xft";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/emacs-22.0.50-pre-xft.tar.bz2;
    md5 = "4f96ada6f18513aeb70adc27b7ac862f";
  };
  patches = [./crt.patch];
  buildInputs = [
    x11
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if xaw3dSupport then Xaw3d else null)
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft libpng] else []);
  configureFlags =
    if gtkGUI then ["--with-x-toolkit=gtk" "--with-xft"] else [];
}
