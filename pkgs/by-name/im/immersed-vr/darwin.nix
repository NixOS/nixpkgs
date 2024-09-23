{ stdenv
, pname
, version
, src
, meta
, undmg
}:

stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  # Immersed is notarized.
  dontFixup = true;
}
