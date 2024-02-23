{ stdenv
, pname
, version
, src
, meta
, unzip
, undmg
}:

stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  # Immersed is notarized.
  dontFixup = true;
}
