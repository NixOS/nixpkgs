{
  lib,
  stdenv,
  fetchMavenArtifact,
  junixsocket-common,
  junixsocket-native-common,
}:

stdenv.mkDerivation rec {
  pname = "postgresql-jdbc";
  version = "42.7.7";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    hash = "sha256-FXlj1grmbWB+CUZujAzfgIfpyyDQFZiZ/8qWvKJShGA=";
    inherit version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/*postgresql-${version}.jar $out/share/java/postgresql-jdbc.jar
    ln -s ${junixsocket-common}/share/java/* $out/share/java/
    ln -s ${junixsocket-native-common}/share/java/* $out/share/java/
    runHook postInstall
  '';

  meta = {
    homepage = "https://jdbc.postgresql.org/";
    changelog = "https://github.com/pgjdbc/pgjdbc/releases/tag/REL${version}";
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = lib.licenses.bsd2;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.unix;
  };
}
