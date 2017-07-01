{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake, libiconv
, drake, ruby, docbook_xsl, file, xdg_utils, gettext, expat, qt5, boost
, libebml, zlib, libmatroska, libogg, libvorbis, flac, libxslt
, withGUI ? true
}:

assert withGUI -> qt5 != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "mbunkus";
    repo = "mkvtoolnix";
    rev = "release-${version}";
    sha256 = "0dz86fzv19wknd8p31nnx2imj80v7m944ssapp8fmq9hkc36m777";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake gettext drake ruby docbook_xsl libxslt ];

  buildInputs = [
    expat file xdg_utils boost libebml zlib libmatroska libogg
    libvorbis flac
  ]
  ++ optional stdenv.isDarwin libiconv
  ++ optionals withGUI [qt5.qtbase qt5.qtmultimedia];

  preConfigure = "./autogen.sh; patchShebangs .";
  buildPhase   = "drake -j $NIX_BUILD_CORES";
  installPhase = "drake install -j $NIX_BUILD_CORES";

  configureFlags = [
    "--enable-magic"
    "--enable-optimization"
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-debug"
    "--disable-profiling"
    "--disable-precompiled-headers"
    "--disable-static-qt"
    "--with-gettext"
    "--with-docbook-xsl-root=${docbook_xsl}/share/xml/docbook-xsl"
    (enableFeature withGUI "qt")
  ];

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage    = http://www.bunkus.org/videotools/mkvtoolnix/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel fuuzetsu rnhmjoj ];
    platforms   = platforms.linux
      ++ optionals (!withGUI) platforms.darwin;
  };
}
