{ stdenvNoCC
, lib
, fetchurl
, undmg
, pname
, version
, sha256
, metaCommon ? { }
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/sindresorhus/caprine/releases/download/v${version}/Caprine-${version}.dmg";
    name = "Caprine-${version}.dmg";
    inherit sha256;
  };

  sourceRoot = "Caprine.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p "$out/Applications/Caprine.app"
    cp -R . "$out/Applications/Caprine.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/Caprine.app/Contents/MacOS/Caprine" "$out/bin/caprine"
  '';

  meta = metaCommon // {
    platforms = with lib.platforms; darwin;
  };
}
