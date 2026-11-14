{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    tag = version;
    hash = "sha256-2a7km8HFGCeVI0nceBs/OtkXC4vW+Nvho7hxIWka89Q=";
  };

  mvnHash = "sha256-IEgYKBRlmfxJF93OuNMSxOKAZ3S+rJb5wvye2fdAD0o=";

  mvnParameters = lib.escapeShellArgs [
    # Skip enrich-sbom: it needs the SBOM from makeBom, which Maven skips when offline
    "-DskipScriptExecution=true"
  ];

  preBuild = ''
    export MAVEN_OPTS="-Djava.io.tmpdir=$TMPDIR"
  '';

  doCheck = false; # Requires networking

  installPhase = ''
    runHook preInstall
    install -m444 -D target/mariadb-java-client-${version}.jar $out/share/java/mariadb-java-client.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MariaDB Connector/J is used to connect applications developed in Java to MariaDB and MySQL databases";
    homepage = "https://mariadb.com/kb/en/about-mariadb-connector-j/";
    changelog = "https://mariadb.com/kb/en/mariadb-connector-j-release-notes/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = lib.platforms.all;
  };
}
