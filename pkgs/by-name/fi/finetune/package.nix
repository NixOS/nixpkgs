{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "finetune";
  version = "1.9.0";

  src = fetchurl {
    name = "FineTune.dmg";
    url = "https://github.com/ronitsingh10/FineTune/releases/download/v${finalAttrs.version}/FineTune.dmg";
    hash = "sha256-K4r5PA8b4YcNSQ/+Pope8uF7yDv0jPxbS4N5GGHN8i4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "FineTune.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R . "$out/Applications/FineTune.app"

    runHook postInstall
  '';

  meta = {
    description = "Per-app volume control, multi-device output, audio routing, and 10-band EQ";
    homepage = "https://github.com/ronitsingh10/FineTune";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      dinckelman
    ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
