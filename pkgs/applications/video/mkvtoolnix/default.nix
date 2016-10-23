{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake
, ruby, file, xdg_utils, gettext, expat, qt5, boost
, libebml, zlib, libmatroska, libogg, libvorbis, flac
, withGUI ? true
}:

assert withGUI -> qt5 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "9.5.0";

  src = fetchFromGitHub {
    owner = "mbunkus";
    repo = "mkvtoolnix";
    rev = "release-${version}";
    sha256 = "1v6rqlb5srhwzad45b50pvfbi1c9n719ihi54hzbkzklj7h4s70h";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake gettext ruby ];

  buildInputs = [
    expat file xdg_utils boost libebml zlib libmatroska libogg
    libvorbis flac
  ] ++ optional withGUI qt5.qtbase;

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
