{
  fetchMavenArtifact,
  junixsocket-common,
}:

fetchMavenArtifact {
  groupId = "com.kohlschutter.junixsocket";
  artifactId = "junixsocket-mysql";
  inherit (junixsocket-common) version;
  hash = "sha256-3xn34WCEO6lZUlnl6eKS5sITz3ihCqQWLSRKngxje30=";
  meta = junixsocket-common.meta // {
    description = "MySQL Connector/J socket factory for Unix domain socket connections via junixsocket";
  };
}
