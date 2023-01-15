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
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';
}
