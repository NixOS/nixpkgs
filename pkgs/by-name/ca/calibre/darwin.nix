{
  pname,
  version,
  meta,
  stdenv,
  fetchurl,
  _7zz,
}:

stdenv.mkDerivation rec {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/calibre-${version}.dmg";
    hash = "sha256-euFJgJzslirAALPaVaNY8LNNoIKRsJaD9gl1nVoRWzU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true; # breaks notarization

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    7zz x -snld $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv Calibre.app $out/Applications
  '';
}
