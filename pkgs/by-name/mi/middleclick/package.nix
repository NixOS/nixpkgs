{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "middleclick";
  version = "3.2.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/artginzburg/MiddleClick/releases/download/${finalAttrs.version}/MiddleClick.zip";
    hash = "sha256-6T8XYSp3QTxefO+UI/DcnbFm1m841B14OpkOLqa6aYw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;
  dontBuild = true;

  # Preserve the upstream Developer ID signature and notarized app bundle.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p unpacked "$out/Applications"
    unzip -q "$src" -d unpacked
    mv unpacked/MiddleClick.app "$out/Applications/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for emulating middle clicks with trackpad and Magic Mouse gestures";
    homepage = "https://github.com/artginzburg/MiddleClick";
    downloadPage = "https://github.com/artginzburg/MiddleClick/releases";
    changelog = "https://github.com/artginzburg/MiddleClick/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ akosseres ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
