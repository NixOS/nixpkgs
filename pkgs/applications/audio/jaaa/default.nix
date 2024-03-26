{ lib, stdenv, fetchurl, alsa-lib, libclthreads, libclxclient, libX11, libXft, libXrender, fftwFloat, libjack2, zita-alsa-pcmi }:

stdenv.mkDerivation rec {
  pname = "jaaa";
  version = "0.9.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1czksxx2g8na07k7g57qlz0vvkkgi5bzajcx7vc7jhb94hwmmxbc";
  };

  buildInputs = [
    alsa-lib libclthreads libclxclient libX11 libXft libXrender fftwFloat libjack2 zita-alsa-pcmi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  meta = with lib; {
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    description = "JACK and ALSA Audio Analyser";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "jaaa";
  };
}
