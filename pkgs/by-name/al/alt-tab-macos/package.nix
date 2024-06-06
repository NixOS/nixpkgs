{
  lib,
  stdenvNoCC,
  fetchurl,
  gitUpdater,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "6.69.0";

  src = fetchurl {
    url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${finalAttrs.version}/AltTab-${finalAttrs.version}.zip";
    hash = "sha256-v0HeucpDGdnK0p9zoYUbEBoHzRMlcJBEIIS1vQZ00A0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/lwouis/alt-tab-macos";
    rev-prefix = "v";
  };

  meta = {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab-macos.netlify.app";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      donteatoreo
      emilytrau
      Enzime
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
