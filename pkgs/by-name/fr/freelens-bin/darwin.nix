{
  stdenvNoCC,
  pname,
  version,
  src,
  passthru,
  meta,
  _7zz,
  autoSignDarwinBinariesHook,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = ".";

  # APFS format is unsupported by undmg
  nativeBuildInputs = [
    _7zz
    autoSignDarwinBinariesHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Freelens*/Freelens.app "$out/Applications/Freelens.app"

    runHook postInstall
  '';
}
