{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "notion-calendar-app";
  version = "1.143.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://calendar-desktop-release.notion-static.com/Notion%20Calendar-1.143.0-arm64.dmg";
    hash = "sha512-jzSN89EHYudwR6NrgCR2C1SOvGPY9Te2XjudEkXh91RBob1fZUOc77+Mi8UAUGjPwYKfgUWFeXli0xLMvUCR1g==";
  };

  sourceRoot = ".";
  nativeBuildInputs = [ undmg ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Notion\ Calendar.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Time, scheduling, and tasks — all in one beautiful calendar.";
    homepage = "https://www.notion.so/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yippii ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
