{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk_headless,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quarkus-cli";
  version = "4.0.1";

  src = fetchurl {
    url = "mirror://maven/io/quarkus/quarkus-cli/${finalAttrs.version}/quarkus-cli-${finalAttrs.version}-runner.jar";
    hash = "sha256-wV9OLpO6LpzUjE0lL9g5VV+0Y/oMhG32hV/dRLw5LAc=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src" "$out/lib/quarkus-cli-${finalAttrs.version}-runner.jar"

    makeWrapper ${jdk_headless}/bin/java "$out/bin/quarkus" \
      --add-flags "-jar $out/lib/quarkus-cli-${finalAttrs.version}-runner.jar"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Kubernetes-native Java framework tailored for GraalVM and HotSpot, crafted from best-of-breed Java libraries and standards";
    homepage = "https://quarkus.io";
    changelog = "https://github.com/quarkusio/quarkus/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vinetos ];
    platforms = lib.platforms.all;
    mainProgram = "quarkus";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
