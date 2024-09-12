{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "6.71.0";

  src = fetchurl {
    url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${finalAttrs.version}/AltTab-${finalAttrs.version}.zip";
    hash = "sha256-46K9ePNqZyaV5Da6VRCT6PvG+Ad0vsuvs7sfNRUbKB4=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab-macos.netlify.app";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donteatoreo emilytrau ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
