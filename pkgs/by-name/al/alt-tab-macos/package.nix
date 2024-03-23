{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "6.66.0";

  src = fetchurl {
    url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${finalAttrs.version}/AltTab-${finalAttrs.version}.zip";
    hash = "sha256-mQ4tS9htL+X4lXqSe3L+mnwgVnHb3Zxyz6dgzmYHY9w=";
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
