{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, stdenv, fetchurl, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null
}:

assert xawSupport && !xaw3dSupport -> libXaw != null;
assert xawSupport && xaw3dSupport -> Xaw3d != null;
assert xpmSupport -> libXpm != null;
assert gtkGUI -> pkgconfig != null && gtk != null;

stdenv.mkDerivation {
  name = "emacs-22.0.50-pre20051207";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/emacs-22.0.50.tar.bz2;
    md5 = "011d40367015691e4319ddc65b4e7843";
  };
  patches = [./crt.patch];
  buildInputs = [
    x11
    (if xawSupport then if xaw3dSupport then Xaw3d else libXaw else null)
    (if xpmSupport then libXpm else null)
  ] ++ (if gtkGUI then [pkgconfig gtk] else []);
  configureFlags =
    if gtkGUI then ["--with-x-toolkit=gtk"] else [];
}
