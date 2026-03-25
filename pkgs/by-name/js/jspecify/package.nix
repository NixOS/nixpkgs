{
  lib,
  stdenvNoCC,
  fetchMavenArtifact,
  jre_minimal,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jspecify";
  version = "1.0.0";

  src = fetchMavenArtifact {
    groupId = "org.jspecify";
    artifactId = "jspecify";
    version = finalAttrs.version;
    hash = "sha256-H61ua+dVd4Hk0zcp1Jrhzcj92m/kd7sMxozjUer9+6s=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 ${finalAttrs.src.jar} $out/share/java/${finalAttrs.pname}-${finalAttrs.version}.jar

    runHook postInstall
  '';

  meta = {
    homepage = "https://jspecify.dev";
    description = "Standard Annotations for Java Static Analysis";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    inherit (jre_minimal.meta) platforms;
    maintainers = with lib.maintainers; [ msgilligan ];
  };
})
