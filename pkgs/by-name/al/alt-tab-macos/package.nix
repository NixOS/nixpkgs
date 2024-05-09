{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "6.68.0";

  src = fetchurl {
    url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${finalAttrs.version}/AltTab-${finalAttrs.version}.zip";
    hash = "sha256-NjDq5Uq771xRHeTipqwTrlz9vBCSsnV34A0482tcZuE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab-macos.netlify.app";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
