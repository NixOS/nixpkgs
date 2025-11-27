{
  stdenvNoCC,
  _7zz,
  makeWrapper,

  pname,
  version,
  src,
  meta,
  passthru,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    passthru
    ;

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
