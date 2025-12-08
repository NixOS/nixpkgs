{
  stdenvNoCC,
  pname,
  version,
  src,
  meta,
  _7zz,
  autoSignDarwinBinariesHook,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
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
    cp -R "Freelens.app" "$out/Applications/Freelens.app"

    runHook postInstall
  '';
}
