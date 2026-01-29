{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seyren";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/scobal/seyren/releases/download/${finalAttrs.version}/seyren-${finalAttrs.version}.jar";
    sha256 = "1fixij04n8hgmaj8kw8i6vclwyd6n94x0n6ify73ynm6dfv8g37x";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p "$out"/bin
    makeWrapper "${jre}/bin/java" "$out"/bin/seyren --add-flags "-jar $src"
  '';

  meta = {
    description = "Alerting dashboard for Graphite";
    mainProgram = "seyren";
    homepage = "https://github.com/scobal/seyren";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.offline ];
    platforms = lib.platforms.all;
  };
})
