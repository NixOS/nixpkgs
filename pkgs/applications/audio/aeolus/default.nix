{ stdenv, fetchurl, libclthreads, zita-alsa-pcmi, alsaLib, libjack2
, libclxclient, libX11, libXft, readline
}:

stdenv.mkDerivation rec {
  pname = "aeolus";
  version = "0.9.8";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1zfr3567mwbqsfybkhg03n5dvmhllk88c9ayb10qzz2nh6d7g2qn";
  };

  buildInputs = [
    libclthreads zita-alsa-pcmi alsaLib libjack2 libclxclient
    libX11 libXft readline
  ];

  patchPhase = ''sed "s@ldconfig.*@@" -i source/Makefile'';

  preBuild = "cd source";

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = {
    description = "Synthetized (not sampled) pipe organ emulator";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
