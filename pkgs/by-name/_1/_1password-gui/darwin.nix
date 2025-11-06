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
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  # 1Password is notarized.
  dontFixup = true;

  passthru.updateScript = ./update.sh;
}
