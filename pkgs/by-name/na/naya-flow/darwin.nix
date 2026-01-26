{
  pname,
  version,
  src,
  passthru,
  meta,

  stdenvNoCC,
  _7zz,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -a NayaFlow.app $out/Applications
    runHook postInstall
  '';
}
