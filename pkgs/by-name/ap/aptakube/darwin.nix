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
    sha256 = "sha256-v6ZDMo79QHNAtDX0idUn5EKQMaNd5PnuyA7QG91JzvI=";
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
