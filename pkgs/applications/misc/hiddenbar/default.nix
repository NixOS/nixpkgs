{ lib
, stdenvNoCC
, fetchurl
, undmg
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hiddenbar";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/dwarvesf/hidden/releases/download/v${finalAttrs.version}/Hidden.Bar.${finalAttrs.version}.dmg";
    sha256 = "00kdnb5639i2mqgmcwby2izb9282f4a91qzbib0hpi61yljb0m1z";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS utility that helps hide menu bar icons";
    homepage = "https://github.com/dwarvesf/hidden";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
