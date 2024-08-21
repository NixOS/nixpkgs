{
  stdenv,
  pname,
  version,
  src,
  meta,
  unzip,
  undmg,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    unzip
    undmg
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  # 1Password is notarized.
  dontFixup = true;
}
