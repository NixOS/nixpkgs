{ stdenv, fetchurl, enchant, qt4, zlib, sox, libX11, xproto, libSM
, libICE, qca2, pkgconfig, callPackage, which, glib
, libXScrnSaver, scrnsaverproto
}:

stdenv.mkDerivation rec {
  name = "psi-0.15";

  src = fetchurl {
    url = "mirror://sourceforge/psi/${name}.tar.bz2";
    sha256 = "593b5ddd7934af69c245afb0e7290047fd7dedcfd8765baca5a3a024c569c7e6";
  };

  buildInputs =
    [ enchant qt4 zlib sox libX11 xproto libSM libICE
      qca2 pkgconfig which glib scrnsaverproto libXScrnSaver
    ];

  NIX_CFLAGS_COMPILE="-I${qca2}/include/QtCrypto";

  NIX_LDFLAGS="-lqca";

  enableParallelBuilding = true;

  meta = {
    description = "Psi, an XMPP (Jabber) client";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
