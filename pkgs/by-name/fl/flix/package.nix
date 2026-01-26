{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "flix";
  version = "0.67.2";

  src = fetchurl {
    url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
    sha256 = "sha256-MWK6Az135IHIzXMUQeHyeb2PROXyeLKyFjIUnDD47T8=";
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
