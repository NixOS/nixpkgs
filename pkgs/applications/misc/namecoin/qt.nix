{ fetchgit, stdenv, db4, boost, openssl, qt4, unzip, namecoin }:

stdenv.mkDerivation rec {
  version = namecoin.version;
  name = "namecoin-qt-${version}";

  src = namecoin.src;

  # Don't build with miniupnpc due to namecoin using a different verison that
  # ships with NixOS and it is API incompatible.
  buildInputs = [ db4 boost openssl unzip qt4 ];

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

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "http://namecoin.info";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
