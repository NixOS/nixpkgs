{
  lib,
  stdenv,
  fetchMavenArtifact,
}:

stdenv.mkDerivation rec {
  pname = "sqlite-jdbc";
  version = "3.49.1.0";

  src = fetchMavenArtifact {
    groupId = "org.xerial";
    artifactId = "sqlite-jdbc";
    inherit version;
    hash = "sha256-XIYJ0so0HeuMb3F3iXS1ukmVx9MtfHyJ2TkqPnLDkpE=";
  };

  installPhase = ''
    install -m444 -D ${src}/share/java/*${pname}-${version}.jar "$out/share/java/${pname}-${version}.jar"
  '';

  meta = {
    homepage = "https://github.com/xerial/sqlite-jdbc";
    description = "Library for accessing and creating SQLite database files in Java";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
}
