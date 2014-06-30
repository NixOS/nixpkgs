{ fetchgit, stdenv, db4, boost, openssl, qt4, unzip, namecoin }:

stdenv.mkDerivation rec {
  version = "0.3.75";
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
    license = "MIT";
    maintainers = [ "Chris Double <chris.double@double.co.nz>" ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
