{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rectangle-pro";
  version = "3.63";

  src = fetchurl {
    url = "https://rectangleapp.com/pro/downloads/Rectangle%20Pro%20${finalAttrs.version}.dmg";
    hash = "sha256-ysRIf19Woo6odCEgkNfoRDelF7gflDhaiNH+hjygz/Q=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  meta = {
    changelog = "https://rectangleapp.com/pro/versions";
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/pro";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
