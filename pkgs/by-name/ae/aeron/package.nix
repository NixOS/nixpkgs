{
  lib,
  stdenv,
  fetchMavenArtifact,
  jdk11,
  makeWrapper,
}:

let
  pname = "aeron";
  version = "1.44.1";
  groupId = "io.aeron";

  aeronAll_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-all";
    hash = "sha512-NyhYaQqOWcSBwzwpje6DMAp36CEgGSNXBSdaRrDyP+Fn2Z0nvh5o2czog6GKKtbjH9inYfyyF/21gehfgLF6qA==";
  };

  aeronSamples_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-samples";
    hash = "sha512-vyAq4mfLDDyaVk7wcIpPvPcxSt92Ek8mxfuuZwaX+0Wu9oJCpwbnjvS9+bvzcE4qSGxzY6eJIIX6nMdw0LkACg==";
  };

  aeronAll_1_42_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.42.1";
    hash = "sha512-pjX+JopK6onDwElMIroj+ZXrKwdPj5H2uPg08XgNlrK1rAkHo9MUT8weBGbuFVFDLeqOZrHj0bt1wJ9XgYY5aA==";
  };

  aeronSamples_1_42_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.42.1";
    artifactId = "aeron-samples";
    hash = "sha512-4JnHn22vJf2lmOg6ev5PD+/YiaL3KgfuyWAK92djX3KBVXO7ERMY2kH79dveVCJG1rbekvE1j1pnjaAIxwJcqg==";
  };

  aeronAll_1_43_0 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.43.0";
    hash = "sha512-ZKjUA1Kp++RLnCNUOi2K/iGc4zIIR4pC4j8qPfO+rcgp7ghZfgsXO8sB+JD307kzeikUXnPFX7ef28DlzI8s8Q==";
  };

  aeronSamples_1_43_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.43.0";
    artifactId = "aeron-samples";
    hash = "sha512-a/ti4Kd8WwzOzDGMgdYk0pxsu8vRA4kRD9cm4D3S+r6xc/rL8ECHVoogOMDeabDd1EYSIbx/sKE01BJOW7BVsg==";
  };

  aeronAll_1_44_1 = fetchMavenArtifact {
    inherit groupId;
    artifactId = "aeron-all";
    version = "1.44.1";
    hash = "sha256-O80bWp7F6mRh3me1znzpfFfFEpvvMVjL4PrAt7+3Fq0=";
  };

  aeronSamples_1_44_1 = fetchMavenArtifact {
    inherit groupId;
    version = "1.44.1";
    artifactId = "aeron-samples";
    hash = "sha256-ZSuTed45BRzr4JJuGeXghUgEifv/FpnCzTNJWa+nwjo=";
  };

  aeronAll = aeronAll_1_44_1;
  aeronSamples = aeronSamples_1_44_1;

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

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    mainProgram = "${pname}-media-driver";
    maintainers = [ maintainers.vaci ];
    sourceProvenance = [
      sourceTypes.binaryBytecode
    ];
  };
}
