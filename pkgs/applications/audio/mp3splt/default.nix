{ fetchurl, stdenv, libmp3splt, pkgconfig }:

stdenv.mkDerivation rec {
  name = "mp3splt-2.6.1";

  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/mp3splt/${name}.tar.gz";
    sha256 = "783a903fafbcf47f06673136a78b78d32a8e616a6ae06b79b459a32090dd14f7";
  };

  buildInputs = [ libmp3splt pkgconfig ];

  meta = {
    description = "utility to split mp3, ogg vorbis and FLAC files without decoding";
    homepage = http://sourceforge.net/projects/mp3splt/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.bosu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
