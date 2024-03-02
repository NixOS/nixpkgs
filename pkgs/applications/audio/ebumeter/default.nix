{ lib, stdenv, fetchurl
, libX11, libXft, libclthreads, libclxclient, libjack2, libpng, libsndfile, zita-resampler
}:

stdenv.mkDerivation rec {
  pname = "ebumeter";
  version = "0.5.1";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.xz";
    hash = "sha256-U2ZpNfvy+X1RdA9Q4gvFYzAxlgc6kYjJpQ/0sEX0A4I=";
  };

  buildInputs = [
    libX11 libXft libclthreads libclxclient libjack2 libpng libsndfile zita-resampler
  ];

  preConfigure = ''
    cd source
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Level metering according to the EBU R-128 recommendation";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
