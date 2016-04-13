{ stdenv, fetchurl, libclthreads, zita-alsa-pcmi, alsaLib, libjack2
, libclxclient, libX11, libXft, readline}:

stdenv.mkDerivation rec {
  name = "aeolus-${version}";
  version = "0.9.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0dkkibza25a6z9446njqlaynx8gfk5wb828pl9v1snmi5390iggp";
  };

  buildInputs = [ libclthreads zita-alsa-pcmi alsaLib libjack2 libclxclient
    libX11 libXft readline ];

  patchPhase = ''sed "s@ldconfig.*@@" -i source/Makefile'';

  preBuild = "cd source";

  makeFlags = "DESTDIR= PREFIX=$(out)";

  meta = {
    description = "Synthetized (not sampled) pipe organ emulator";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
