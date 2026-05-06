{
  stdenv,
  pname,
  version,
  src,
  passthru,
  meta,
  undmg,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Lens.app" "$out/Applications/Lens.app"

    runHook postInstall
  '';

  dontFixup = true;
}
