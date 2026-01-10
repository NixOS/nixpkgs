{
  lib,
  stdenv,
  fetchMavenArtifact,
  jdk11,
  makeWrapper,
}:

let
  pname = "aeron";
  version = "1.49.0";
  groupId = "io.aeron";

  aeronAll_1_49_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.49.0";
    hash = "sha256-n3qoLs+iYzrb95skr29DrpQPHsWBZL6IygnayNJ1s6Q=";
  };

  aeronSamples_1_49_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.49.0";
    artifactId = "aeron-samples";
    hash = "sha256-ePhAUBebeZP5exfBOGpUTTntAeZIdsolPuyhpbv0GVo=";
  };

  aeronAll = aeronAll_1_49_0;
  aeronSamples = aeronSamples_1_49_0;

in
stdenv.mkDerivation {

  inherit pname version;

  buildInputs = [
    aeronAll
    aeronSamples
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/share/java"
    ln --symbolic "${aeronAll.jar}" "$out/share/java/${pname}-all.jar"
    ln --symbolic "${aeronSamples.jar}" "$out/share/java/${pname}-samples.jar"

    runHook postInstall
  '';

  postFixup = ''
    function wrap {
      makeWrapper "${jdk11}/bin/java" "$out/bin/$1" \
        --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
        --add-flags "--class-path ${aeronAll.jar}" \
        --add-flags "$2"
    }

    wrap "${pname}-media-driver" io.aeron.driver.MediaDriver
    wrap "${pname}-stat" io.aeron.samples.AeronStat
    wrap "${pname}-archiving-media-driver" io.aeron.archive.ArchivingMediaDriver
    wrap "${pname}-archive-tool" io.aeron.archive.ArchiveTool
    wrap "${pname}-logging-agent" io.aeron.agent.DynamicLoggingAgent
    wrap "${pname}-clustered-media-driver" io.aeron.cluster.ClusteredMediaDriver
    wrap "${pname}-cluster-tool" io.aeron.cluster.ClusterTool
  '';

  passthru = {
    jar = aeronAll.jar;
  };

  meta = {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = lib.licenses.asl20;
    mainProgram = "${pname}-media-driver";
    maintainers = [ lib.maintainers.vaci ];
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
    ];
  };
}
