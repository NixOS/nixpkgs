args : with args; 
rec {
  src = fetchurl {
    url = ftp://ftp.ru.debian.org/debian/pool/main/p/psi/psi_0.11.orig.tar.gz;
    sha256 = "1rgjahngari4pwhi0zz9mricaaqxkk8ry8w6s1vgsq3zwa2l5x57";
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
