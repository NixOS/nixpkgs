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
  name = "mkvtoolnix-6.1.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "01k5al3886cyi97kynx5hf98z5p7mb8vd2m057gbp1k10zblcb9x";
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
