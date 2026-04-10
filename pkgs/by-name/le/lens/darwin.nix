{
  stdenv,
  pname,
  version,
  src,
  meta,
  undmg,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
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
