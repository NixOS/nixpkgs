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
  name = "mkvtoolnix-6.2.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0864vmdcnfwk5cb2fv1y60yvp9kqcyaqxwbvy4nsj7bzwv1iqysn";
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
