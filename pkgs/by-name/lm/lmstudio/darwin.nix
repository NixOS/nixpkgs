{ stdenv
, fetchurl
, undmg
, lib
, meta
, pname
, version
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-byS0LNJQjs/+sf2anhTAdsXUWad9HujxmLx5uEfdlo8=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';
}

