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
  src =
    let
      arch = if stdenvNoCC.hostPlatform.system == "x86_64-darwin" then "x86_64" else "arm64";
    in
    fetchurl {
      urls = [
        "https://www.sws-extension.org/download/featured/sws-${finalAttrs.version}-Darwin-${arch}.dmg"
        "https://www.sws-extension.org/download/old/sws-${finalAttrs.version}-Darwin-${arch}.dmg"
      ];
      hash =
        {
          x86_64 = "sha256-7wSgiaOcCHpUXBtOBdTTi385M94i8FnWCAp4cN0Rycs=";
          arm64 = "sha256-AzOLBgh3WECqbFHMTZ4EBGNLpAleXFJT2USzh7pDkQA=";
        }
        .${arch};
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
