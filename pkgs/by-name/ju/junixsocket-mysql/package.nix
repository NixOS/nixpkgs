{
  fetchMavenArtifact,
  junixsocket-common,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-mysql";
  inherit (junixsocket-common) version;
  hash = "sha256-TakO7qEpGQqcJVAhhFUVPUroLvJuD8G12T348cFzPqE=";
  meta = junixsocket-common.meta // {
    description = "MySQL Connector/J socket factory for Unix domain socket connections via junixsocket";
  };
}
