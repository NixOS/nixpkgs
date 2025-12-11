{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "loopwm";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/MrKai77/Loop/releases/download/${finalAttrs.version}/Loop.zip";
    hash = "sha256-UiEUdRKQLJdOj+fI4fmTi71TreP1gM+jr+53dhtESRE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications,bin}
    cp -r Loop.app $out/Applications
    makeWrapper $out/Applications/Loop.app/Contents/MacOS/Loop $out/bin/loopwm \
      --set LOOP_SKIP_UPDATE_CHECK 1
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "macOS Window management made elegant";
    homepage = "https://github.com/MrKai77/Loop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matteopacini ];
    mainProgram = "loopwm";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
