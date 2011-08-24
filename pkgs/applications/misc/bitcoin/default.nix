{ fetchurl, stdenv, openssl, db4, boost, zlib, glib, libSM, gtk, wxGTK, miniupnpc }:

stdenv.mkDerivation rec {
  version = "0.3.24";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/bitcoin/Bitcoin/${name}/${name}-src.tar.gz";
    sha256 = "18n8i37c478b275m2x82411i1fsw8l34qm1k65ynnw38fpaj4h3r";
  };

  buildInputs = [ openssl db4 boost zlib glib libSM gtk wxGTK miniupnpc ];

  preConfigure = ''
    cd src
    substituteInPlace makefile.unix \
      --replace "-Wl,-Bstatic" "" \
      --replace "-Wl,-Bdynamic" "" \
      --replace "DEBUGFLAGS=-g -D__WXDEBUG__" "DEBUGFLAGS=" \
  '';

  makefile = "makefile.unix";

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
