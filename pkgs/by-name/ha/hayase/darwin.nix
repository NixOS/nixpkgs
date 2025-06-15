{
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeWrapper,

  pname,
  version,
  meta,
  passthru,
}:
stdenvNoCC.mkDerivation rec {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/mac-hayase-${version}-mac.dmg";
    hash = "sha256-OpRIr1aQhKX0RC8djYIfnvIBa4gjowNWFGByx5MzMnE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,Applications}
    cp -r Hayase.app $out/Applications/
    makeWrapper $out/Applications/Hayase.app/Contents/MacOS/Hayase $out/bin/hayase
    runHook postInstall
  '';
}
