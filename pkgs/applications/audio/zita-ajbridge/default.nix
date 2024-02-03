{ lib, stdenv, fetchurl, alsa-lib, libjack2, zita-alsa-pcmi, zita-resampler }:

stdenv.mkDerivation rec {
  pname = "zita-ajbridge";
  version = "0.8.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0g5v0l0zmqh049mhv62n8s5bpm0yrlby7mkxxhs5qwadp8v4w9mw";
  };

  buildInputs = [ alsa-lib libjack2 zita-alsa-pcmi zita-resampler ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man/man1"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Connect additional ALSA devices to JACK";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
