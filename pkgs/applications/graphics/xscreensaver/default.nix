{ stdenv, fetchurl, pkgconfig, bc, perl, xlibs, libjpeg, mesa, gtk                     
, libxml2, libglade }:                                                                 

stdenv.mkDerivation rec {
  name = "xscreensaver-5.10";

  src = fetchurl {
    url = "http://www.jwz.org/xscreensaver/${name}.tar.gz";
    sha256 = "07zy157wqwgcapqycyv89yabxa8byk4p8jn3zlvhf7lx5w1xmval";
  };

  buildInputs =
    [ pkgconfig bc perl libjpeg mesa gtk libxml2 libglade
      xlibs.xlibs xlibs.libXmu
    ];

  configureFlags =
    [ "--with-gl"
      "--with-dpms"
      "--with-pixbuf"
      "--with-x-app-defaults=\$out/share/xscreensaver/app-defaults"
      "--with-hackdir=\$out/share/xscreensaver-hacks"
    ];

  preConfigure =
    ''
      sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
        -i driver/Makefile.in po/Makefile.in.in
    '';

  meta = {
    description = "A set of screensavers";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.allBut "i686-cygwin";
  };
}
