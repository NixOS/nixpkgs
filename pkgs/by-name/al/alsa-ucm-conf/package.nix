{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-OHwBzzDioWdte49ysmgc8hmrynDdHsKp4zrdW/P+roE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
