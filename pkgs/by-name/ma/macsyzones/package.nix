{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macsyzones";
  version = "3.0.4";

  src = fetchurl {
    url = "https://github.com/rohanrhu/MacsyZones/releases/download/v${finalAttrs.version}/MacsyZones.zip";
    hash = "sha256-owOkhPP597XaNgMe19zhPcYw0wHc4aqFDy4zcgFPbHo=";
  };

  dontUnpack = true;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FancyZones equivalent for macOS to organize windows into custom snap layouts";
    homepage = "https://macsyzones.com";
    changelog = "https://github.com/rohanrhu/MacsyZones/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ mschuwalow ];
    platforms = lib.platforms.darwin;
  };
})
