{ stdenv, db4, boost, openssl, qt4, miniupnpc, unzip, namecoind }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "namecoin-${version}";
  version = namecoind.version;
  src = namecoind.src;

  buildInputs = [ db4 boost openssl unzip qt4 miniupnpc ];

  configurePhase = ''
    qmake USE_UPNP=-
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp namecoin-qt $out/bin
  '';

  meta = namecoind.meta;
}
