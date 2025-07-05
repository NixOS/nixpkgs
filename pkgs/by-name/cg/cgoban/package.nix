{
  lib,
  stdenv,
  temurin-jre-bin-17,
  fetchurl,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "cgoban";
  version = "3.5.144";

  nativeBuildInputs = [
    temurin-jre-bin-17
    makeWrapper
  ];

  src = fetchurl {
    url = "https://web.archive.org/web/20240314222506/https://files.gokgs.com/javaBin/cgoban.jar";
    hash = "sha256-ehN/aQU23ZEtDh/+r3H2PDPBrWhgoMfgEfKq5q08kFY=";
  };

  dontConfigure = true;
  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/lib/cgoban.jar
    makeWrapper ${temurin-jre-bin-17}/bin/java $out/bin/cgoban --add-flags "-jar $out/lib/cgoban.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Client for the KGS Go Server";
    mainProgram = "cgoban";
    homepage = "https://www.gokgs.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.free;
    maintainers = with maintainers; [ savannidgerinel ];
    platforms = temurin-jre-bin-17.meta.platforms;
  };
}
