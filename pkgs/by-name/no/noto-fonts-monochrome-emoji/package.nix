{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
}:

stdenvNoCC.mkDerivation {
  pname = "noto-fonts-monochrome-emoji";
  version = "";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "b979dba422e445492b0eb9951ac52ee0b4d648c3";
    hash = "sha256-cZeMMVUUXGjShTrD5PkPEDMkqnXSuyfIlp6hP8nkXUU=";
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
