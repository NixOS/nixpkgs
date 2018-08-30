{ stdenv, fetchurl, alsaLib, libclthreads, libclxclient, libX11, libXft, libXrender, fftwFloat, libjack2, zita-alsa-pcmi }:

stdenv.mkDerivation rec {
  name = "jaaa-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0jyll4rkb6vja2widc340ww078rr24c6nmxbxdqvbxw409nccd01";
  };

  buildInputs = [
    alsaLib libclthreads libclxclient libX11 libXft libXrender fftwFloat libjack2 zita-alsa-pcmi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  meta = with stdenv.lib; {
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    description = "JACK and ALSA Audio Analyser";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
