{ stdenv, fetchurl
, libmatroska
, flac
, libvorbis
, file
, boost
, lzo
, xdg_utils
, expat
, wxGTK
, zlib
, ruby
, gettext
, pkgconfig
, curl
}:

stdenv.mkDerivation rec {
  name = "mkvtoolnix-5.6.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.bz2";
    sha256 = "1hzwf4zaamny3qzmd6hyhy4hy9l67s3fjvznbi0avw0ad7g05i89";
  };

  buildInputs = [ libmatroska flac libvorbis file boost lzo xdg_utils expat wxGTK zlib ruby gettext pkgconfig curl ];

  configureFlags = "--with-boost-libdir=${boost}/lib";
  buildPhase = ''
    ruby ./drake
  '';

  installPhase = ''
    ruby ./drake install
  '';

  meta = {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
  };
}

