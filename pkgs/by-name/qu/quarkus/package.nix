{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quarkus-cli";
  version = "3.11.1";

  src = fetchurl {
    url = "https://github.com/quarkusio/quarkus/releases/download/${finalAttrs.version}/quarkus-cli-${finalAttrs.version}.tar.gz";
    hash = "sha256-eR3/DDO50KYVI14iX+IvALK4YLx0hmd9Z4rToPQTBGE=";
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
    license = licenses.asl20;
    maintainers = [ maintainers.vinetos ];
    platforms = platforms.all;
    mainProgram = "quarkus";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
