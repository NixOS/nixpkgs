{
  fetchurl,
  stdenv,
  makeWrapper,
  undmg,
  pname,
  commonMeta,
  version,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    ;

  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${builtins.substring 0 7 version}_x64.dmg";
    hash = "sha256-AA9J3wyz2huLSGVvjA/st1kb6aDT6uQA1Ut21S1GU2M=";
  };

  nativeBuildInputs = [
    makeWrapper
    undmg
  ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications/GoldenCheetah.app"
    cp -r * "$out/Applications/GoldenCheetah.app/"
    makeWrapper "$out/Applications/GoldenCheetah.app/Contents/MacOS/GoldenCheetah" "$out/bin/GoldenCheetah"
    runHook postInstall
  '';
  meta = {
    inherit (commonMeta)
      description
      platforms
      maintainers
      license
      sourceProvenance
      ;
  };
}
