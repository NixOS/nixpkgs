{
  stdenv,
  lib,
  undmg,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "Skim";
  version = "1.7.9";

  src = fetchurl {
    name = "Skim-${version}.dmg";
    url = "mirror://sourceforge/project/skim-app/Skim/Skim-${version}/Skim-${version}.dmg";
    hash = "sha256-0IfdLeH6RPxf4OZWnNltN7tvvZWbWDQaMCmazd4UUi4=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Skim.app $out/Applications
    runHook postInstall
  '';

  meta = with lib; {
    description = "PDF reader and note-taker for macOS";
    homepage = "https://skim-app.sourceforge.io/";
    license = licenses.bsd0;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "Skim.app";
    maintainers = with maintainers; [ YvesStraten ];
    platforms = platforms.darwin;
  };
}
