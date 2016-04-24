{ stdenv, db4, boost, openssl, qt4, qmake4Hook, miniupnpc, unzip, namecoind }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "namecoin-${version}";
  version = namecoind.version;
  src = namecoind.src;

  buildInputs = [ db4 boost openssl unzip qt4 qmake4Hook miniupnpc ];

  qmakeFlags = [ "USE_UPNP=-" ];

  installPhase = ''
    mkdir -p $out/bin
    cp namecoin-qt $out/bin
  '';

  meta = namecoind.meta;
}
