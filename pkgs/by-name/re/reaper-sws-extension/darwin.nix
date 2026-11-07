{
  stdenvNoCC,
  fetchurl,
  pname,
  version,
  meta,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    ;
  src = fetchurl {
    urls = [
      "https://www.sws-extension.org/download/featured/sws-${finalAttrs.version}-Darwin-arm64.dmg"
      "https://www.sws-extension.org/download/old/sws-${finalAttrs.version}-Darwin-arm64.dmg"
    ];
    hash = "sha256-AzOLBgh3WECqbFHMTZ4EBGNLpAleXFJT2USzh7pDkQA=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Data
    cp -r Grooves $out/Data
    install -D *.py -t $out/Scripts
    install -D *.dylib -t $out/UserPlugins

    runHook postInstall
  '';
})
