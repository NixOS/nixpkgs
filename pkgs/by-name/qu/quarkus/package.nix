{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quarkus-cli";
  version = "3.13.0";

  src = fetchurl {
    url = "https://github.com/quarkusio/quarkus/releases/download/${finalAttrs.version}/quarkus-cli-${finalAttrs.version}.tar.gz";
    hash = "sha256-KWVbEtT3uluvLqbRk4tLPA7tGn9gf+Ee5hBrzlWtuhg=";
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

  meta = with lib; {
    description = "Quarkus is a Kubernetes-native Java framework tailored for GraalVM and HotSpot, crafted from best-of-breed Java libraries and standards";
    homepage = "https://quarkus.io";
    changelog = "https://github.com/quarkusio/quarkus/releases/tag/${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = [ maintainers.vinetos ];
    platforms = platforms.all;
    mainProgram = "quarkus";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
