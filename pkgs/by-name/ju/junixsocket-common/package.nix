{
  fetchMavenArtifact,
  lib,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-common";
  version = "2.10.1";
  hash = "sha256-GeX3YVrSKT81Mrw/mRsxOWwRYYNOidmmqgx975OcZyk=";
  meta = {
    homepage = "https://kohlschutter.github.io/junixsocket/";
    description = "Java/JNI library that allows the use of Unix Domain Sockets (AF_UNIX sockets) and other socket types, such as AF_TIPC and AF_VSOCK, from Java, using the standard Socket API";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.vog ];
  };
}
