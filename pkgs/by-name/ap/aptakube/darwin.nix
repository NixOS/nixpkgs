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
    sha256 = "sha256-6X/IsukSpUJrcqcJWcYd5kczyVNe8WOtfbp0ErgdS+A=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r Aptakube.app $out/Applications/Aptakube.app
  '';
}
