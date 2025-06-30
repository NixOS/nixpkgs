{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "duckstation-bin";
  version = "0.1-7371";

  src = fetchurl {
    url = "https://github.com/stenzek/duckstation/releases/download/v${finalAttrs.version}/duckstation-mac-release.zip";
    hash = "sha256-ukORbTG0lZIsUInkEnyPB9+PwFxxK5hbgj9D6tjOEAY=";
  };

  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r DuckStation.app $out/Applications/DuckStation.app
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    changelog = "https://github.com/stenzek/duckstation/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
