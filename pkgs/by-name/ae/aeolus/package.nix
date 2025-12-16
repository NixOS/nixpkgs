{
  lib,
  stdenv,
  fetchurl,
  libclthreads,
  zita-alsa-pcmi,
  alsa-lib,
  libjack2,
  libclxclient,
  libX11,
  libXft,
  readline,
  aeolus-stops,
}:

stdenv.mkDerivation rec {
  pname = "aeolus";
  version = "0.10.4";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-J9xrd/N4LrvGgi89Yj4ob4ZPUAEchrXJJQ+YVJ29Qhk=";
  };

  buildInputs = [
    libclthreads
    zita-alsa-pcmi
    alsa-lib
    libjack2
    libclxclient
    libX11
    libXft
    readline
  ];

  postPatch = ''
    sed -i source/Makefile -e /ldconfig/d
    substituteInPlace source/main.cc --replace /etc/ "$out/etc/"
  '';

  preBuild = "cd source";

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postInstall =
    let
      cfg = ''
        # Aeolus system wide default options
        # Ignored if ~/.aeolusrc with local options exists
        -u -S ${aeolus-stops}/${aeolus-stops.subdir}
      '';
    in
    ''
      mkdir -p $out/etc
      echo -n "${cfg}" > $out/etc/aeolus.conf
    '';

  meta = {
    description = "Synthetized (not sampled) pipe organ emulator";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nico202
    ];
    mainProgram = "aeolus";
  };
}
