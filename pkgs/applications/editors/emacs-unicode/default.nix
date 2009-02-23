{ xawSupport ? true
, xpmSupport ? true
, dbusSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchcvs, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null, dbus ? null
, libpng, libjpeg, libungif, libtiff, texinfo
, autoconf, automake
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert dbusSupport -> dbus != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

let date = "2009-02-16"; in
stdenv.mkDerivation {
  name = "emacs-snapshot-23-${date}";
  
  builder = ./builder.sh;
  
  src = fetchcvs {
    inherit date;
    cvsRoot = ":pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs";
    module = "emacs";
    sha256 = "6ec63da94a199c5f95bf4a9aa578cf14b3d85800fd37b3562d9a446b144b0d47";
  };

  preConfigure = "autoreconf -vfi";
  
  buildInputs = [
    autoconf automake
    ncurses x11 texinfo
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if dbusSupport then dbus else null)
    (if xaw3dSupport then Xaw3d else null)
    libpng libjpeg libungif libtiff # maybe not strictly required?
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft] else []);
  
  configureFlags = "
    ${if gtkGUI then "--with-x-toolkit=gtk --enable-font-backend --with-xft" else ""}
  ";

  meta = {
    description = "GNU Emacs with Unicode, GTK and Xft support (23.x alpha)";
    homepage = http://www.emacswiki.org/cgi-bin/wiki/XftGnuEmacs;
    license = "GPLv3+";
  };
}
