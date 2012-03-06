{stdenv, fetchurl, ncurses, pkgconfig, glib, libviper, libpseudo, gpm,
libvterm}:

stdenv.mkDerivation rec {
  name = "vwm-2.1.3";
 
  src = fetchurl {
    url = "mirror://sourceforge/vwm/${name}.tar.gz";
    sha256 = "1r5wiqyfqwnyx7dfihixlnavbvg8rni36i4gq169aisjcg7laxaf";
  };

  prePatch = ''
    sed -i -e s@/usr/local@$out@ \
      -e s@/usr/lib@$out/lib@ \
      -e 's@tic vwmterm@tic -o '$out/lib/terminfo' vwmterm@' \
      -e /ldconfig/d Makefile modules/*/Makefile vwm.h
  '';

  preInstall = ''
    mkdir -p $out/bin $out/include
  '';
 
  buildInputs = [ ncurses pkgconfig glib libviper libpseudo gpm libvterm ];
 
  meta = {
    homepage = http://vwm.sourceforge.net/;
    description = "Dynamic window manager for the console";
    license="GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
