{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

let
  sources = lib.importJSON ./sources.json;
  platform =
    sources.platforms.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "screendrop";
  inherit (sources) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/fayazara/Screendrop/releases/download/${sources.tag}/${platform.filename}";
    inherit (platform) hash;
  };

  sourceRoot = "Screendrop.app";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Screendrop.app"
    cp -R . "$out/Applications/Screendrop.app"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/Screendrop.app/Contents/MacOS/Screendrop" "$out/bin/screendrop"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Native macOS screenshot and screen recording tool";
    homepage = "https://github.com/fayazara/Screendrop";
    changelog = "https://github.com/fayazara/Screendrop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "screendrop";
    platforms = lib.attrNames sources.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
