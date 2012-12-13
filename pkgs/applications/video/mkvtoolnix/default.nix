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
  name = "mkvtoolnix-5.9.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.bz2";
    sha256 = "1qdxzi72w5p77brlpp7y7llsgzlvl4p8fk1kzg934cqw6cqza4yr";
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

