{ stdenv, fetchurl, scons, pkgconfig
, libsamplerate, libsndfile, liblo, libjack2, boost }:

stdenv.mkDerivation rec {
  name = "klick-${version}";
  version = "0.12.2";

  src = fetchurl {
    url = "http://das.nasophon.de/download/${name}.tar.gz";
    sha256 = "1289533c0849b1b66463bf27f7ce5f71736b655cfb7672ef884c7e6eb957ac42";
  };

  buildInputs = [ scons pkgconfig libsamplerate libsndfile liblo libjack2 boost ];

  buildPhase = ''
    mkdir -p $out
    scons PREFIX=$out
  '';

  installPhase = "scons install";

  meta = {
    homepage = "http://das.nasophon.de/klick/";
    description = "Advanced command-line metronome for JACK";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

