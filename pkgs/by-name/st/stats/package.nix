{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.10.10";

  src = fetchurl {
    url = "https://github.com/exelban/stats/releases/download/v${finalAttrs.version}/Stats.dmg";
    hash = "sha256-CdTY5Qv/xF9ItNgHQFqec5nKObnImx/+MuFShTfdrAo=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
