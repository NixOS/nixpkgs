{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchurl, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null, libpng ? null
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

stdenv.mkDerivation {
  name = "emacs-23.0.0.1-pre20070214";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/emacs-snapshot_20070214.orig.tar.gz;
    sha256 = "0nx6i9vw4m5kqhylrf04jnh0hs26hiv98jxqfpk4amh2m976z2rn";
  };
  patches = [
    ./crt.patch
    # From Debian: use --enable-font-backend by default.
    ./xft-default.patch
  ];
  buildInputs = [
    ncurses x11
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if xaw3dSupport then Xaw3d else null)
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft libpng] else []);
  configureFlags = "
    ${if gtkGUI then "--with-gtk --enable-font-backend --with-xft" else ""}
  ";

  meta = {
    description = "Emacs with Unicode, GTK and Xft support (23.x alpha)";
    url = http://www.emacswiki.org/cgi-bin/wiki/XftGnuEmacs;
  };
}
