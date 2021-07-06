{ lib, stdenv, fetchFromGitLab, pkg-config, autoconf, automake, libiconv, drake
, ruby, docbook_xsl, file, xdg-utils, gettext, expat, boost, libebml, zlib
, fmt, libmatroska, libogg, libvorbis, flac, libxslt, cmark, pcre2
, withGUI ? true
  , qtbase ? null
  , qtmultimedia ? null
  , wrapQtAppsHook ? null
}:

assert withGUI -> qtbase != null && qtmultimedia != null && wrapQtAppsHook != null;

with lib;

stdenv.mkDerivation rec {
  pname = "mkvtoolnix";
  version = "56.0.0";

  src = fetchFromGitLab {
    owner  = "mbunkus";
    repo   = "mkvtoolnix";
    rev    = "release-${version}";
    sha256 = "0nhpp1zkggxqjj7lhj6as5mcjcz5yk3l1d1xcgs7i9153blam1yj";
  };

  nativeBuildInputs = [
    pkg-config autoconf automake gettext
    drake ruby docbook_xsl libxslt
  ];

  buildInputs = [
    expat file xdg-utils boost libebml zlib fmt
    libmatroska libogg libvorbis flac cmark pcre2
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

  CXXFLAGS = optional stdenv.cc.isClang "-std=c++17";
  LDFLAGS = optional stdenv.cc.isClang "-lc++fs";

  dontWrapQtApps = true;
  postFixup = optionalString withGUI ''
    wrapQtApp $out/bin/mkvtoolnix-gui
  '';

  meta = with lib; {
    description = "Cross-platform tools for Matroska";
    homepage    = "http://www.bunkus.org/videotools/mkvtoolnix/";
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ codyopel rnhmjoj ];
    platforms   = platforms.linux
      ++ optionals (!withGUI) platforms.darwin;
  };
}
