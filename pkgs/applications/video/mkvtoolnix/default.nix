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
  version = "7.5.0";
  name = "mkvtoolnix-${version}";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0ksv79zcpp34jzs77r02x119c0h2wyvkgckd0bbwjix0qyczgfhp";
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
