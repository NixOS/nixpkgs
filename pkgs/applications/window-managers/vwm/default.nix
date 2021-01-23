{lib, stdenv, fetchurl, ncurses, pkg-config, glib, libviper, libpseudo, gpm,
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses glib libviper libpseudo gpm libvterm ];

  meta = with lib; {
    homepage = "http://vwm.sourceforge.net/";
    description = "Dynamic window manager for the console";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
