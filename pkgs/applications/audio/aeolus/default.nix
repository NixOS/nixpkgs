{ lib, stdenv, fetchurl, libclthreads, zita-alsa-pcmi, alsa-lib, libjack2
, libclxclient, libX11, libXft, readline
}:

stdenv.mkDerivation rec {
  pname = "aeolus";
  stopsVersion = "0.4.0";
  version = "0.10.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-J9xrd/N4LrvGgi89Yj4ob4ZPUAEchrXJJQ+YVJ29Qhk=";
  };

  stops = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/stops-${stopsVersion}.tar.bz2";
    sha256 = "0e79a0b8e006cb0f67bfcf1e9097db0b4e10c1bb30e6d5c401a29e882411fcb0";
  };

  buildInputs = [
    libclthreads zita-alsa-pcmi alsa-lib libjack2 libclxclient
    libX11 libXft readline
  ];

  patchPhase = ''
    sed "s@ldconfig.*@@" -i source/Makefile
    sed -i 's@/etc@'$out'/etc@' -i source/main.cc
  '';

  preBuild = "cd source";

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];


  postInstall = ''
    mkdir -p $out/share/stops
    tar xavf ${stops} --strip-components=1 -C $out/share/stops/
    mkdir $out/etc
    cat <<EOF >$out/etc/aeolus.conf
    # Aeolus system wide default options
    # use ~/.aeolusrc for local options
    -u -S $out/share/stops/
    EOF
  '';

  meta = {
    description = "Synthetized (not sampled) pipe organ emulator";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
