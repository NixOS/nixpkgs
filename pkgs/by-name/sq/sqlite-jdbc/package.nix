{
  lib,
  stdenv,
  fetchMavenArtifact,
}:

stdenv.mkDerivation rec {
  pname = "sqlite-jdbc";
  version = "3.25.2";

  src = fetchMavenArtifact {
    groupId = "org.xerial";
    artifactId = "sqlite-jdbc";
    inherit version;
    sha256 = "1xk5fi2wzq3jspvbdm5hvs78501i14jy3v7x6fjnh5fnpqdacpd4";
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
