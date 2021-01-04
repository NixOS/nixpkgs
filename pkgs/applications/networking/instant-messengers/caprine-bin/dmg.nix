{ stdenvNoCC
, lib
, fetchurl
, undmg
}:

let
  common-attrs = import ./common-attrs.nix { inherit lib fetchurl; };
  inherit (common-attrs) pname version;
  nameApp = "Caprine.app";
  inherit (common-attrs.dmg) src;
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

  meta = common-attrs.metaCommon // { platforms = with lib.platforms; darwin; };
}
