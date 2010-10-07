{ stdenv, fetchurl, cmake, qt4, libgadu, libXScrnSaver, libsndfile, qca2
, libX11, alsaLib }:

stdenv.mkDerivation {

  name = "kadu-0.6.5.4";

  src = fetchurl {
    url = http://www.kadu.net/download/stable/kadu-0.6.5.4.tar.bz2;
    sha256 = "09bdcyx75lca1pl6x3vfpawmdjn5pfxvwivb9xdhk4bdvswxgv4x";
  };
  
  buildInputs = [
    cmake qt4 libgadu libXScrnSaver libsndfile qca2 libX11 alsaLib
  ];

  cmakeFlags = "-DENABLE_AUTODOWNLOAD=OFF";

  prePatch = ''
    patchShebangs .
  '';

  meta = { 
    description = "An instance messanger client for the gadu-gadu network (most popular polish IM network)";
    homepage = http://www.kadu.net/w/English:Main_Page;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
