{
  stdenvNoCC,
  fetchurl,
  undmg,

  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    meta
    ;

  src = fetchurl {
    url = "https://github.com/aptakube/aptakube/releases/download/${version}/Aptakube_${version}_universal.dmg";
    sha256 = "sha256-ljVl490cZuIcRSP8RKmf8Eq5D4OibLfuA8SugUlf1Yw=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    runHook preUnpack
    undmg $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Aptakube.app $out/Applications/Aptakube.app
    runHook postInstall
  '';
}
