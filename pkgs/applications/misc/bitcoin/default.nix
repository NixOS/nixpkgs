{ fetchurl, stdenv, openssl, db4, boost, zlib, glib, libSM, gtk, wxGTK, miniupnpc }:

stdenv.mkDerivation rec {
  version = "0.3.22";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/bitcoin/Bitcoin/${name}/${name}-linux.tar.gz";
    sha256 = "1nyji3xjyvw91snnbxk71dih3yf292d7mvkakw0nkqplbap14xjb";
  };

  buildInputs = [ openssl db4 boost zlib glib libSM gtk wxGTK miniupnpc ];

  preConfigure = ''
    cd src/src
    substituteInPlace makefile.unix \
      --replace "-Wl,-Bstatic" "" \
      --replace "-Wl,-Bdynamic" "" \
      --replace "DEBUGFLAGS=-g -D__WXDEBUG__" "DEBUGFLAGS=" \
  '';

  makefile = "makefile.unix";

  preBuild = "make -f ${makefile} clean";

  buildFlags = "bitcoin bitcoind";

  installPhase = ''
    ensureDir $out/bin
    cp bitcoin $out/bin
    cp bitcoind $out/bin
  '';

  meta = { 
      description = "Bitcoin is a peer-to-peer currency";
      longDescription=''
Bitcoin is a free open source peer-to-peer electronic cash system that is
completely decentralized, without the need for a central server or trusted
parties.  Users hold the crypto keys to their own money and transact directly
with each other, with the help of a P2P network to check for double-spending.
      '';
      homepage = "http://www.bitcoin.org/";
      maintainers = [ stdenv.lib.maintainers.roconnor ];
      license = "MIT";
  };
}
