{
  fetchMavenArtifact,
  junixsocket-common,
  lib,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-native-common";
  inherit (junixsocket-common) version;
  hash = "sha256-mqDbOPdrSZ42wrVue/VHLOsZrU0h6+cbJdG8gfAzYEA=";
  meta = junixsocket-common.meta // {
    description = "Binaries of the native JNI library for junixsocket for common platforms";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
