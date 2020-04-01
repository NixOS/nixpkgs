{ stdenv, fetchurl
, cairo, fftwSinglePrec, libX11, libXft, libclthreads, libclxclient, libjack2
, xorgproto, zita-resampler
}:

stdenv.mkDerivation rec {
  name = "zita-at1-0.6.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0mxfn61zvhlq3r1mqipyqzjbanrfdkk8x4nxbz8nlbdk0bf3vfqr";
  };

  buildInputs = [
    cairo fftwSinglePrec libX11 libXft libclthreads libclxclient libjack2
    xorgproto zita-resampler
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Autotuner Jack application to correct the pitch of vocal tracks";
    homepage = https://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
