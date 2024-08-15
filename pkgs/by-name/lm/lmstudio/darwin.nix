{ stdenv
, fetchurl
, undmg
, meta
, pname
, version
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/1/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-ZitdLHuGIH22Ohk7UWVz32BPFTj796HoR+5zEs5rh6E=";
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

