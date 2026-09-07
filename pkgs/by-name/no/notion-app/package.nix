{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
let
  info = lib.importJSON ./source.json;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "notion-app";
  version = info.version;

  src = fetchurl { inherit (info) url hash; };

  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Notion.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = ./update/update.mjs;

  meta = {
    description = "App to write, plan, collaborate, and get organised";
    homepage = "https://www.notion.so/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      pradyuman
    ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
