{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "stops";
  version = "0.4.0";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/stops-${version}.tar.bz2";
    hash = "sha256-DnmguOAGyw9nv88ekJfbC04Qwbsw5tXEAaKeiCQR/LA=";
  };

  outputHashMode = "recursive";
  outputHash = "sha256-gGHowq7g7MZmnhrpqG+3wNLwQCtpiBB88euIKeQIpJ0=";

  subdir = "share/Aeolus/stops";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${subdir}
    cp -r * $out/${subdir}

    runHook postInstall
  '';

  meta = {
    description = "Aeolus synthesizer instrument definitions";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nico202
    ];
  };
}
