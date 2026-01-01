{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quarkus-cli";
<<<<<<< HEAD
  version = "3.30.5";

  src = fetchurl {
    url = "https://github.com/quarkusio/quarkus/releases/download/${finalAttrs.version}/quarkus-cli-${finalAttrs.version}.tar.gz";
    hash = "sha256-x+G4DwqRMNEO75NND5r388pWnDZMjG7o/6MoCfVZyvk=";
=======
  version = "3.29.4";

  src = fetchurl {
    url = "https://github.com/quarkusio/quarkus/releases/download/${finalAttrs.version}/quarkus-cli-${finalAttrs.version}.tar.gz";
    hash = "sha256-ApMv7nHYBaW/L0Gvs6M8rJc3n/9yhSRtSAnWda06iak=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp ./lib/quarkus-cli-${finalAttrs.version}-runner.jar $out/lib

    makeWrapper ${jdk}/bin/java $out/bin/quarkus \
          --add-flags "-classpath $out/lib/quarkus-cli-${finalAttrs.version}-runner.jar" \
          --add-flags "-Dapp.name=quarkus" \
          --add-flags "-Dapp-pid='\$\$'" \
          --add-flags "-Dapp.repo=$out/lib" \
          --add-flags "-Dapp.home=$out" \
          --add-flags "-Dbasedir=$out" \
          --add-flags "io.quarkus.cli.Main"

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Kubernetes-native Java framework tailored for GraalVM and HotSpot, crafted from best-of-breed Java libraries and standards";
    homepage = "https://quarkus.io";
    changelog = "https://github.com/quarkusio/quarkus/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vinetos ];
    platforms = lib.platforms.all;
    mainProgram = "quarkus";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
=======
  meta = with lib; {
    description = "Kubernetes-native Java framework tailored for GraalVM and HotSpot, crafted from best-of-breed Java libraries and standards";
    homepage = "https://quarkus.io";
    changelog = "https://github.com/quarkusio/quarkus/releases/tag/${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = [ maintainers.vinetos ];
    platforms = platforms.all;
    mainProgram = "quarkus";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
