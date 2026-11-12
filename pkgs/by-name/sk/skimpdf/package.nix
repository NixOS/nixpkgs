{
  stdenv,
  lib,
  undmg,
  fetchurl,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "Skim";
  version = "1.7.9";

  src = fetchurl {
    name = "Skim-${version}.dmg";
    url = "mirror://sourceforge/project/skim-app/Skim/Skim-${version}/Skim-${version}.dmg";
    hash = "sha256-0IfdLeH6RPxf4OZWnNltN7tvvZWbWDQaMCmazd4UUi4=";
  };

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    cp -R Skim.app $out/Applications
    for app in displayline skimnotes skimpdf; do
      makeWrapper $out/Applications/Skim.app/Contents/SharedSupport/$app $out/bin/$app
    done
    runHook postInstall
  '';

  meta = {
    description = "PDF reader and note-taker for macOS";
    homepage = "https://skim-app.sourceforge.io/";
    license = lib.licenses.bsd0;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "Skim.app";
    maintainers = with lib.maintainers; [ YvesStraten ];
    platforms = lib.platforms.darwin;
  };
}
