args : with args;
rec {
  src = fetchurl {
    url = mirror://sourceforge/psi/psi-0.12.tar.gz;
    sha256 = "6afbb3b017009bf4d8d275ec1481e92831b0618ecb58f1372cd9189140a316af";
  };

  buildInputs = [aspell qt zlib sox openssl libX11 xproto
    libSM libICE];
  configureFlags = [" --with-zlib-inc=${zlib}/include "
    " --with-openssl-inc=${openssl}/include "
  ];

  phaseNames = ["doConfigure" "doMakeInstall"];

  name = "psi-" + version;
  meta = {
    description = "Psi, an XMPP (Jabber) client";
  };
}
