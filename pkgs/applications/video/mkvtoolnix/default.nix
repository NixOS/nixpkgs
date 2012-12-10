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
  name = "mkvtoolnix-5.8.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.bz2";
    sha256 = "0q294zk5cpfh1s89n70d9b2fs14rlacdlnhchlsjmf1mq3jcg7iw";
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

