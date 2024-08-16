{ lib
, stdenvNoCC
, fetchurl
, undmg
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mos";
  version = "3.4.1";

  src = fetchurl {
    url = "https://github.com/Caldis/Mos/releases/download/${finalAttrs.version}/Mos.Versions.${finalAttrs.version}.dmg";
    sha256 = "38ea33e867815506414323484147b882b6d97df4af9759bca0a64d98c95029b3";
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
    description = "Smooths scrolling and set mouse scroll directions independently";
    homepage = "http://mos.caldis.me/";
    changelog = "https://github.com/Caldis/Mos/releases/tag/${finalAttrs.version}";
    license = licenses.cc-by-nc-40;
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
  };
})
