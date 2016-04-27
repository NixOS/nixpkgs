{ stdenv, fetchgit, pkgconfig, autoconf, automake
, ruby, file, xdg_utils, gettext, expat, qt5, boost
, libebml, zlib, libmatroska, libogg, libvorbis, flac
, withGUI ? true
}:

assert withGUI -> qt5 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "8.9.0";

  src = fetchgit {
    url = "https://github.com/mbunkus/mkvtoolnix.git";
    rev = "54e6b52b3dde07f89da4542997ef059e18802128";
    sha256 = "1hm9f9q60c0axmmlsalazsiil8gk3v8q6cl5qxsfa95m51i39878";
  };

  nativeBuildInputs = [ gettext ruby ];

  buildInputs = [
    pkgconfig autoconf automake expat
    file xdg_utils boost libebml zlib
    libmatroska libogg libvorbis flac
    (optional withGUI qt5.qtbase)
  ];

  preConfigure = "./autogen.sh; patchShebangs .";
  buildPhase   = "./drake -j $NIX_BUILD_CORES";
  installPhase = "./drake install -j $NIX_BUILD_CORES";

  configureFlags = [
    "--enable-magic"
    "--enable-optimization"
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-debug"
    "--disable-profiling"
    "--disable-precompiled-headers"
    "--disable-static-qt"
    "--without-curl"
    "--with-gettext"
    (enableFeature withGUI "qt")
  ];

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage    = http://www.bunkus.org/videotools/mkvtoolnix/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel fuuzetsu rnhmjoj ];
    platforms   = platforms.linux;
  };
}
