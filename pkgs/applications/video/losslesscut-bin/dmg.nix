{ stdenvNoCC, lib, fetchurl, undmg, version , sha256 }:

let
  pname = "losslesscut";
  nameRepo = "lossless-cut";
  nameCamel = "LosslessCut";
  nameSource = "${nameCamel}-mac.dmg";
  nameApp = nameCamel + ".app";
  owner = "mifi";
  src = fetchurl {
    url = "https://github.com/${owner}/${nameRepo}/releases/download/v${version}/${nameSource}";
    name = nameSource;
    inherit sha256;
  };
in stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg ${src}
  '';
  sourceRoot = nameApp;

  installPhase = ''
    mkdir -p $out/Applications/${nameApp}
    cp -R . $out/Applications/${nameApp}
  '';

  meta.platforms = lib.platforms.darwin;
}
