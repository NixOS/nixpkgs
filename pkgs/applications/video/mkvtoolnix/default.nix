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
}:

stdenv.mkDerivation rec {
  name = "mkvtoolnix-4.4.0";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.bz2";
    sha256 = "0apgmah1d4dh5x1phr4n5vgwmy0w1nym9pydzh4kdgcs167l8n6l";
  };

  buildInputs = [ libmatroska flac libvorbis file boost lzo xdg_utils expat wxGTK zlib ruby gettext ];

  configureFlags = "--with-boost-libdir=${boost}/lib";
  buildPhase = ''
    ruby ./drake
  '';

  installPhase = ''
    ruby ./drake install
  '';

  meta = {
    description = "Matroska library";
    homepage = http://dl.matroska.org/downloads/libmatroska;
  };
}

