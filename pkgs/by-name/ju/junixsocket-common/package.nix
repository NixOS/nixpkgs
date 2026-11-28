{
  fetchMavenArtifact,
  lib,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-common";
  version = "2.11.1";
  hash = "sha256-FSaAWJo1ms1zdz4+fZ2YQgB7e4bY+OD4KOH4eoGtXWo=";
  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://kohlschutter.github.io/junixsocket/";
    description = "Java/JNI library that allows the use of Unix Domain Sockets (AF_UNIX sockets) and other socket types, such as AF_TIPC and AF_VSOCK, from Java, using the standard Socket API";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with lib.maintainers; [
      vog
      anish
    ];
  };
}
