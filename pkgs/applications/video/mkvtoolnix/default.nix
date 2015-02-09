{ stdenv, fetchurl
, libmatroska
, flac
, libvorbis
, file
, boost
, xdg_utils
, expat
, withGUI ? true
, wxGTK
, zlib
, ruby
, gettext
, pkgconfig
, curl
}:

assert withGUI -> wxGTK != null;

stdenv.mkDerivation rec {
  version = "7.6.0";
  name = "mkvtoolnix-${version}";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "1n6waln6r9jx26al3k2nh6wi8p1q6lv2fs48nbc1lj9s2fc35pkl";
  };

  buildInputs = [
    libmatroska flac libvorbis file boost xdg_utils
    expat zlib ruby gettext pkgconfig curl
    ] ++ stdenv.lib.optional withGUI wxGTK;

  configureFlags = "--with-boost-libdir=${boost.lib}/lib";
  buildPhase = ''
    ruby ./drake
  '';

  installPhase = ''
    ruby ./drake install
  '';

  meta = {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
