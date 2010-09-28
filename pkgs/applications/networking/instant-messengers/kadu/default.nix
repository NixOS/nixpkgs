{ stdenv, fetchurl, cmake, qt, libgadu, bash, libXScrnSaver, libsndfile, qca2, wget, libX11, alsaLib }:

stdenv.mkDerivation {

  name = "kadu-0.6.5.4";

  src = fetchurl {
    url = http://www.kadu.net/download/stable/kadu-0.6.5.4.tar.bz2;
    sha256 = "09bdcyx75lca1pl6x3vfpawmdjn5pfxvwivb9xdhk4bdvswxgv4x";
  };
  
  buildInputs = [
    cmake qt libgadu bash libXScrnSaver libsndfile qca2 wget libX11 alsaLib
  ];

  cmakeFlags = "-Wno-dev";

  NIX_LDFLAGS="-lX11";

  patches = [ ./more-icons.patch ];

  patchPhase = ''
    unset patchPhase; patchPhase
    sed 's=/bin/bash=/${stdenv.shell}=g' -i \
      `find -type f -name '*.sh' -or -name 'autodownload'`
  '';

  meta = { 
    description = "An instance messanger client for the gadu-gadu network (most popular polish IM network)";
    homepage = http://www.kadu.net/w/English:Main_Page;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
