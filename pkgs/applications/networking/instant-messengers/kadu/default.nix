{ stdenv, fetchurl, cmake, qt4, libgadu, libXScrnSaver, libsndfile, libX11,
  alsaLib, aspell, libidn, qca2, phonon }:

stdenv.mkDerivation {

  name = "kadu-0.9.2";

  src = fetchurl {
    url = http://www.kadu.net/download/stable/kadu-0.9.2.tar.bz2;
    sha256 = "05lpx7m2adx8vv4h62rsiwlgay24m6cxdbibg7vzl4xkq9ybv30b";
  };

  buildInputs = [
    cmake qt4 libgadu libXScrnSaver libsndfile libX11 alsaLib aspell libidn qca2 phonon
  ];

  configureFlags = "CPPFLAGS=-DQT_NO_DEBUG";

  cmakeFlags = "-DENABLE_AUTODOWNLOAD=OFF -DBUILD_DESCRIPTION='NixOS' -DCMAKE_BUILD_TYPE=Release";

  prePatch = ''
    patchShebangs .
  '';

  patches = [ ./config.patch ];

  NIX_LDFLAGS="-lX11";

  meta = {
    description = "An instant-messenger client for the gadu-gadu network (most popular polish IM network)";
    homepage = http://www.kadu.net/w/English:Main_Page;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
