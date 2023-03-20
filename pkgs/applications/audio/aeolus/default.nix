{ lib, stdenv, fetchurl, libclthreads, zita-alsa-pcmi, alsa-lib, libjack2
, libclxclient, libX11, libXft, readline
}:

stdenv.mkDerivation rec {
  pname = "aeolus";
  version = "0.10.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-J9xrd/N4LrvGgi89Yj4ob4ZPUAEchrXJJQ+YVJ29Qhk=";
  };

  buildInputs = [
    libclthreads zita-alsa-pcmi alsa-lib libjack2 libclxclient
    libX11 libXft readline
  ];

  patchPhase = ''sed "s@ldconfig.*@@" -i source/Makefile'';

  preBuild = "cd source";

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = {
    description = "Synthetized (not sampled) pipe organ emulator";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
