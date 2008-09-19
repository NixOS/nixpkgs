{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchurl, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null
, libpng, libjpeg, libungif, libtiff
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

stdenv.mkDerivation {
  name = "emacs-snapshot-23.0.0.1-pre20070705";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://debs.peadrop.com/pool/edgy/backports/emacs-snapshot_20070705.orig.tar.gz;
    sha256 = "1blybacpsxha2v24kj482wl3g1z93rwddfc8rsqsk6dr6f5kdj5q";
  };

#  patches = [
#    ./crt.patch
#  ];
  
  buildInputs = [
    ncurses x11
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if xaw3dSupport then Xaw3d else null)
    libpng libjpeg libungif libtiff # maybe not strictly required?
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft] else []);
  
  configureFlags = "
    ${if gtkGUI then "--with-gtk --enable-font-backend --with-xft" else ""}
  ";

  meta = {
    description = "Emacs with Unicode, GTK and Xft support (23.x alpha)";
    homepage = http://www.emacswiki.org/cgi-bin/wiki/XftGnuEmacs;
    license = "GPL";
  };
}
