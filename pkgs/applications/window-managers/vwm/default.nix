{stdenv, fetchurl, ncurses, pkgconfig, glib, libviper, libpseudo, gpm}:

stdenv.mkDerivation {
  name = "vwm-2.0.1";
 
  src = fetchurl {
    url = mirror://sourceforge/vwm/vwm-2.0.1.tar.gz;
    sha256 = "1kn1ga35kvl10s3xvgr5ys18gd4pp0gwah4pnvmfkvg0xazjrc0h";
  };

  prePatch = ''
    sed -i -e s@/usr/local@$out@ \
      -e s@/usr/lib@$out/lib@ \
      -e 's@tic vwmterm@tic -o '$out/lib/terminfo' vwmterm@' \
      -e /ldconfig/d Makefile modules/*/Makefile vwm.h
  '';

  patches = [ ./signal.patch ];

  preInstall = ''
    ensureDir $out/bin $out/include
  '';
 
  buildInputs = [ ncurses pkgconfig glib libviper libpseudo gpm];
 
  meta = {
    homepage = http://vwm.sourceforge.net/;
    description = "Dynamic window manager for the console";
    license="GPLv2+";
  };
}
