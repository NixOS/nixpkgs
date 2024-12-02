{ lib
, stdenvNoCC
, fetchFromGitHub
, rename
}:

stdenvNoCC.mkDerivation {
  pname = "noto-fonts-monochrome-emoji";
  version = "3.000";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "a73b9ab0a5df191bcfed817159a903911ea7958a";
    hash = "sha256-qVFU4uZius8oFPJCIL9ek2YdS3jru5mmTHp2L9RIXfg=";
    sparseCheckout = [ "ofl/notoemoji" ];
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/noto ofl/notoemoji/*.ttf
    ${rename}/bin/rename 's/\[.*\]//' $out/share/fonts/noto/*

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Monochrome emoji font";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Emoji";
    license = [ lib.licenses.ofl ];
    maintainers = [ lib.maintainers.nicoo ];

    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
