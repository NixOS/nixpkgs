{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "flix";
  version = "0.71.0";

  src = fetchurl {
    url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
    sha256 = "sha256-Ha5oRDpQ7YuGsaF/ZNx8b+HjTSroxZEjzI3zR3g7NXI=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/flix/flix.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/flix \
      --add-flags "-jar $JAR"

    runHook postInstall
  '';

  meta = {
    description = "Flix Programming Language";
    mainProgram = "flix";
    homepage = "https://github.com/flix/flix";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ athas ];
    inherit (jre.meta) platforms;
  };
}
