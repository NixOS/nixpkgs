{ lib, stdenv, fetchurl, xorg, fftwSinglePrec, zita-resampler, libclxclient, libclthreads, cairo, libjack2, pkgconf }:

stdenv.mkDerivation rec {
  pname = "zita-lrx";
  version = "0.1.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "54740dc563ffb3f0a26aabd20dc6905f42a4e77dfb80ae71c3a2899eb8418c97";
  };

  buildInputs = with xorg; [
    fftwSinglePrec zita-resampler libclxclient libX11 libXft libclthreads cairo libjack2
    pkgconf
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A command line application providing crossover filters for Jack";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aloiscochard ];
    platforms = platforms.linux;
  };
}

