{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ksnip-bin";
  version = "1.10.1";

  src = fetchurl {
    url = "https://github.com/ksnip/ksnip/releases/download/v${finalAttrs.version}/ksnip-${finalAttrs.version}.dmg";
    hash = "sha256-oCk2SVHgN38+Ylp69wMT0SZhRaYhhejhJyhrVWSxHgg=";
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
    description = "ksnip the cross-platform screenshot and annotation tool";
    homepage = "https://github.com/ksnip/ksnip";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rickyelopez ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
