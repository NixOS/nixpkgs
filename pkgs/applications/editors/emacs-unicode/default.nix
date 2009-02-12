{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchurl, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null
, libpng, libjpeg, libungif, libtiff, texinfo
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

let date = "20080228"; in
stdenv.mkDerivation {
  name = "emacs-snapshot-23-${date}";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://ppa.launchpad.net/avassalotti/ubuntu/pool/main/e/emacs-snapshot/emacs-snapshot_${date}.orig.tar.gz";
    sha256 = "1cix1qjrynidvdyww3g8fm1wyggc82qjxbfbv3rx630szm1v6bm7";
  };

#  patches = [
#    ./crt.patch
#  ];
  
  buildInputs = [
    ncurses x11 texinfo
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if xaw3dSupport then Xaw3d else null)
    libpng libjpeg libungif libtiff # maybe not strictly required?
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft] else []);
  
  configureFlags = "
    ${if gtkGUI then "--with-x-toolkit=gtk --enable-font-backend --with-xft" else ""}
  ";

  meta = {
    description = "Emacs with Unicode, GTK and Xft support (23.x alpha)";
    homepage = http://www.emacswiki.org/cgi-bin/wiki/XftGnuEmacs;
    license = "GPLv3+";
  };
}
