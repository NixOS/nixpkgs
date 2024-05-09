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
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/b/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-kb1XoTZjhCL1+CsV+r3/EN0srzIJ43H2VMZ779dVq1k=";
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

