{ stdenv, fetchurl, cmake, qt4, libgadu, libXScrnSaver, libsndfile, libX11,
  alsaLib, aspell, libidn, qca2, phonon, pkgconfig }:

stdenv.mkDerivation {

  name = "kadu-0.10.1";

  src = fetchurl {
    url = http://download.kadu.im/stable/kadu-0.10.1.tar.bz2;
    sha256 = "0j88pyp2nqpc57j38zr135ypfiv4v329gfgiz9rdbqi8j26cyp7g";
  };

  buildInputs = [ cmake qt4 libgadu libXScrnSaver libsndfile libX11 alsaLib aspell libidn qca2 phonon pkgconfig
  ];

  configureFlags = "CPPFLAGS=-DQT_NO_DEBUG";

  cmakeFlags = "-DENABLE_AUTODOWNLOAD=OFF -DBUILD_DESCRIPTION='NixOS' -DCMAKE_BUILD_TYPE=Release";

  prePatch = ''
    patchShebangs .
  '';

  # because I was not able to get those working
  patches = [ ./disable_some_plugins.patch ];

  NIX_LDFLAGS="-lX11";

  meta = {
    description = "An instant-messenger client for the gadu-gadu network (most popular polish IM network)";
    homepage = http://www.kadu.net/w/English:Main_Page;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
