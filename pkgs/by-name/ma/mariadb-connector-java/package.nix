{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "3.5.7";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    tag = version;
    hash = "sha256-ScdrBSJKbVyD/omPrxiZvuaa5uOo2d3SqX/ozalMWHk=";
  };

  mvnHash = "sha256-pQYLMsxNVdby4WkO/dznIqqeu2dTtiBjrpJ/A3MuJ5Y=";

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
