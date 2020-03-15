{ stdenv, fetchFromGitLab, pkgconfig, autoconf, automake, libiconv, drake
, ruby, docbook_xsl, file, xdg_utils, gettext, expat, boost, libebml, zlib
, fmt, libmatroska, libogg, libvorbis, flac, libxslt, cmark
, withGUI ? true
  , qtbase ? null
  , qtmultimedia ? null
  , wrapQtAppsHook ? null
}:

assert withGUI -> qtbase != null && qtmultimedia != null && wrapQtAppsHook != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mkvtoolnix";
  version = "44.0.0";

  src = fetchFromGitLab {
    owner  = "mbunkus";
    repo   = "mkvtoolnix";
    rev    = "release-${version}";
    sha256 = "072sw51svaizqi9f6kscic23wxcjarwgb7nv52yd5si5w8s0qh9r";
  };

  nativeBuildInputs = [
    pkgconfig autoconf automake gettext
    drake ruby docbook_xsl libxslt
  ];

  buildInputs = [
    expat file xdg_utils boost libebml zlib fmt
    libmatroska libogg libvorbis flac cmark
  ] ++ optional  stdenv.isDarwin libiconv
    ++ optionals withGUI [ qtbase qtmultimedia wrapQtAppsHook ];

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

  CXXFLAGS = optional stdenv.cc.isClang "-std=c++14";

  dontWrapQtApps = true;
  postFixup = optionalString withGUI ''
    wrapQtApp $out/bin/mkvtoolnix-gui
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage    = http://www.bunkus.org/videotools/mkvtoolnix/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel rnhmjoj ];
    platforms   = platforms.linux
      ++ optionals (!withGUI) platforms.darwin;
  };
}
