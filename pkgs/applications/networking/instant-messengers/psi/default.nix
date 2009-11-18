{ stdenv, fetchurl, aspell, qt4, zlib, sox, libX11, xproto, libSM, libICE, qca2 }:

stdenv.mkDerivation rec {
  name = "psi-0.12.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/psi/${name}.tar.bz2";
    sha256 = "0zi71fcia9amcasa6zrvfyghdpqa821iv2rkj53bq5dyvfm2y0m8";
  };

  buildInputs = [aspell qt4 zlib sox libX11 xproto libSM libICE qca2];

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
