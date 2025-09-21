{
  fetchMavenArtifact,
  junixsocket-common,
  lib,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-native-common";
  inherit (junixsocket-common) version;
  hash = "sha256-ASbOC68c61de9ReAfU0rFLnzLwYYAgThLsc6tKdyVno=";
  meta = junixsocket-common.meta // {
    description = "Binaries of the native JNI library for junixsocket for common platforms";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
