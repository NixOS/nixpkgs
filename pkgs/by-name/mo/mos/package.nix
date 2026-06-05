{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mos";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/Caldis/Mos/releases/download/${finalAttrs.version}/Mos.Versions.${finalAttrs.version}-20260505.1.zip";
    hash = "sha256-SswAG7V+7LbAbPcHwS4Kr+0TFg6XWhYTEK7lVC3lYCQ=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  meta = {
    description = "Smooths scrolling and set mouse scroll directions independently on macOS";
    homepage = "https://mos.caldis.me/";
    changelog = "https://github.com/Caldis/Mos/releases/tag/${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-40;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
  };
})
