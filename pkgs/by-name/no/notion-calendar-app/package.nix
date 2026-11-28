{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "notion-calendar-app";
  version = "1.144.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://calendar-desktop-release.notion-static.com/Notion%20Calendar-${finalAttrs.version}-arm64.dmg";
    hash = "sha256-KplrhTzGvRh9T6Jswx1SCrB+epx1NgzKE8jDOgyFzeE=";
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
    homepage = "https://www.notion.com/product/calendar";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yippii ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
