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
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/${revision}/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-jXL+8JTu1X3pLT2Jqge+tZrIjW+/IxbvsYvrML2WFaw=";
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

