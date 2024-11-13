{
  directoryListingUpdater,
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.13";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-ucm-conf-${version}.tar.bz2";
    hash = "sha256-RIO245g8ygj9Mmpz+65Em1A25ET7GgfA3udLUEt6ta8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://www.alsa-project.org/files/pub/lib/";
  };

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
