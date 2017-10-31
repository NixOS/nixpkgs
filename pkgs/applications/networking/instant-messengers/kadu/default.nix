{ stdenv, fetchurl, cmake, qt4, libgadu, libXScrnSaver, libsndfile, libX11,
  alsaLib, aspell, libidn, qca2, phonon, pkgconfig }:

stdenv.mkDerivation {

  name = "kadu-0.12.3";

  src = fetchurl {
    url = http://download.kadu.im/stable/kadu-0.12.3.tar.bz2;
    sha256 = "1a5q5b8pm253cwg6ahahjdm8jxj0pv41apyi1nvvy08bs38bn1yn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake qt4 libgadu libXScrnSaver libsndfile libX11 alsaLib aspell libidn qca2 phonon
  ];

  configureFlags = "CPPFLAGS=-DQT_NO_DEBUG";

  preConfigure = ''
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${phonon}/lib64/pkgconfig:${phonon}/lib32/pkgconfig"
  '';

  cmakeFlags = "-DENABLE_AUTODOWNLOAD=OFF -DBUILD_DESCRIPTION='NixOS'";

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
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
