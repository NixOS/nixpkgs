{ stdenv, fetchurl,   alsaLib, libjack2, fftwFloat, libclthreads, libclxclient, libX11,  libXft, zita-alsa-pcmi, }:

stdenv.mkDerivation rec {
  version = "0.8.4";
  name = "japa-${version}";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "1jhj7s4vqk5c4lchdall0kslvj5sh91902hhfjvs6r3a5nrhwcp0";
  };

  buildInputs = [ alsaLib libjack2 fftwFloat libclthreads libclxclient libX11 libXft zita-alsa-pcmi ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  meta = {
    description = "A 'perceptual' or 'psychoacoustic' audio spectrum analyser for JACK and ALSA";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
