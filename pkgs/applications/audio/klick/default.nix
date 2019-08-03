{ stdenv, fetchurl, sconsPackages, pkgconfig
, libsamplerate, libsndfile, liblo, libjack2, boost }:

stdenv.mkDerivation rec {
  name = "klick-${version}";
  version = "0.12.2";

  src = fetchurl {
    url = "http://das.nasophon.de/download/${name}.tar.gz";
    sha256 = "1289533c0849b1b66463bf27f7ce5f71736b655cfb7672ef884c7e6eb957ac42";
  };

  nativeBuildInputs = [ sconsPackages.scons_3_0_1 pkgconfig ];
  buildInputs = [ libsamplerate libsndfile liblo libjack2 boost ];
  prefixKey = "PREFIX=";
  NIX_CFLAGS_COMPILE = "-fpermissive";

  meta = {
    homepage = http://das.nasophon.de/klick/;
    description = "Advanced command-line metronome for JACK";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
