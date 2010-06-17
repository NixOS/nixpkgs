{ stdenv, fetchurl, pkgconfig, bc, perl, xlibs, libjpeg, mesa, gtk                     
, libxml2, libglade }:                                                                 

stdenv.mkDerivation rec {
  version = "5.11";
  name = "xscreensaver-${version}";
  url = "http://www.jwz.org/xscreensaver/${name}.tar.gz";

  src = fetchurl {
    inherit url;
    sha256="0w47s0qd8ab6ywhhhkqjx0grb2b28bh2flnkdpj3yaind202l0s7";
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
