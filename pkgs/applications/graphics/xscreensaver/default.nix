x@{ pkgconfig, bc, perl, xlibs, libjpeg, mesa, gtk
, libxml2, libglade, builderDefsPackage, ... }:                                                                 

builderDefsPackage 
(a: rec {
  version = "5.11";
  name = "xscreensaver-${version}";
  url = "http://www.jwz.org/xscreensaver/${name}.tar.gz";

  src = a.fetchurl {
    inherit url;
    sha256="0w47s0qd8ab6ywhhhkqjx0grb2b28bh2flnkdpj3yaind202l0s7";
  };

  buildInputs = with a;
    [ pkgconfig bc perl libjpeg mesa gtk libxml2 libglade
      xlibs.xlibs xlibs.libXmu
    ];

  configureFlags =
    [ "--with-gl"
      "--with-dpms"
      "--with-pixbuf"
      "--with-x-app-defaults=\${out}/share/xscreensaver/app-defaults"
      "--with-hackdir=\${out}/share/xscreensaver-hacks"
    ];

  preConfigure = a.fullDepEntry
    ''
      sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
        -i driver/Makefile.in po/Makefile.in.in
    '' ["minInit" "doUnpack"];

  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  meta = {
    description = "A set of screensavers";
    maintainers = [ a.lib.maintainers.raskin ];
    platforms = a.lib.platforms.allBut "i686-cygwin";
  };
}) x
