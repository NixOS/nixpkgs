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
    sha256 = "89828e1ac030f9532ba24afdd91d357280b32fcc475830b6667d5066e7a576ac";
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
