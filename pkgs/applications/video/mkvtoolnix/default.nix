{ stdenv, fetchurl
, libmatroska
, flac
, libvorbis
, file
, boost
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
  name = "mkvtoolnix-6.5.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0a3h878bsjbpb2r7b528xzyqzl8r82yhrniry9bnhmw7rcl53bd8";
  };

  buildInputs = [ libmatroska flac libvorbis file boost xdg_utils expat wxGTK zlib ruby gettext pkgconfig curl ];

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
