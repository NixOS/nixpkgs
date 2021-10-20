{ lib, stdenv, fetchurl,   alsa-lib, libjack2, fftwFloat, libclthreads, libclxclient, libX11,  libXft, zita-alsa-pcmi, }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "japa";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1zmi4wg23hwsypg3h6y3qb72cbrihqcs19qrbzgs5a67d13q4897";
  };

  buildInputs = [ alsa-lib libjack2 fftwFloat libclthreads libclxclient libX11 libXft zita-alsa-pcmi ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  meta = {
    description = "A 'perceptual' or 'psychoacoustic' audio spectrum analyser for JACK and ALSA";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
