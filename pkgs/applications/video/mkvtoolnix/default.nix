{ stdenv, fetchFromGitLab, pkgconfig, autoconf, automake, libiconv
, drake, ruby, docbook_xsl, file, xdg_utils, gettext, expat, boost
, libebml, zlib, libmatroska, libogg, libvorbis, flac, libxslt, cmark
, withGUI ? true
  , qtbase ? null
  , qtmultimedia ? null
}:

assert withGUI -> qtbase != null && qtmultimedia != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "22.0.0";

  src = fetchFromGitLab {
    owner  = "mbunkus";
    repo   = "mkvtoolnix";
    rev    = "release-${version}";
    sha256 = "07nggqkpl6dkfcqli8y9dn0jbznldz03nqj2l3fgj3vhqa0phlab";
  };

  nativeBuildInputs = [
    pkgconfig autoconf automake gettext
    drake ruby docbook_xsl libxslt
  ];

  buildInputs = [
    expat file xdg_utils boost libebml zlib
    libmatroska libogg libvorbis flac cmark
  ] ++ optional  stdenv.isDarwin libiconv
    ++ optionals withGUI [ qtbase qtmultimedia ];

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
