{
  stdenv,
  fetchurl,
  undmg,
  lib,
  meta,
  pname,
  version,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-wl3uyRtqY5w8NnESBKcP+CicIh8cCkKmrcVuiijzzTQ=";
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
