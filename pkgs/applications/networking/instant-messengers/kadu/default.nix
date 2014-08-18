{ stdenv, fetchurl, cmake, qt4, libgadu, libXScrnSaver, libsndfile, libX11,
  alsaLib, aspell, libidn, qca2, phonon, pkgconfig }:

stdenv.mkDerivation {

  name = "kadu-0.12.2";

  src = fetchurl {
    url = http://download.kadu.im/stable/kadu-0.12.2.tar.bz2;
    sha256 = "0rqhkiyn8c7jigpxmvwh7daxsgjxlvd16zjdss1azdzd9x2dbym1";
  };

  buildInputs = [ cmake qt4 libgadu libXScrnSaver libsndfile libX11 alsaLib aspell libidn qca2 phonon pkgconfig
  ];

  configureFlags = "CPPFLAGS=-DQT_NO_DEBUG";

  cmakeFlags = "-DENABLE_AUTODOWNLOAD=OFF -DBUILD_DESCRIPTION='NixOS' -DCMAKE_BUILD_TYPE=Release";

  prePatch = ''
    patchShebangs .
  '';

  # Disable the kadu plugins I wasn't able to get to work
  patchPhase = ''
    sed -i -e '/mpd_mediaplayer/d' \
           -e '/encryption_ng/d'   \
           -e '/encryption_ng_simlite/d' Plugins.cmake
    patch -p1 < ${./cmake.patch}
  '';

  NIX_LDFLAGS="-lX11";

  meta = {
    description = "An instant-messenger client for the gadu-gadu network (most popular polish IM network)";
    homepage = http://www.kadu.net/w/English:Main_Page;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
