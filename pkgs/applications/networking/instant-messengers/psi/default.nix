{ stdenv, fetchurl, aspell, qt4, zlib, sox, libX11, xproto, libSM, libICE, qca2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "psi-0.14";
  
  src = fetchurl {
    url = "mirror://sourceforge/psi/${name}.tar.bz2";
    sha256 = "1h54a1qryfva187sw9qnb4lv1d3h3lysqgw55v727swvslh4l0da";
  };

  buildInputs = [aspell qt4 zlib sox libX11 xproto libSM libICE qca2 pkgconfig];

  NIX_CFLAGS_COMPILE="-I${qca2}/include/QtCrypto";
  
  NIX_LDFLAGS="-lqca";

  configureFlags =
    [ " --with-zlib-inc=${zlib}/include "
      " --disable-bundled-qca"
    ];

  meta = {
    description = "Psi, an XMPP (Jabber) client";
  };
}
