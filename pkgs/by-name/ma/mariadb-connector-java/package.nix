{ lib
, maven
, fetchFromGitHub
, nix-update-script
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    rev = "refs/tags/${version}";
    hash = "sha256-JuMm01ihgVoKpe8wyuUIDyzSxMODRg7dQpTCyVA/K10=";
  };

  mvnHash = "sha256-Px4Qxb1tTvRKZum1xfe0mdX+EyimnyyfzrydiaDaYRo=";

  # Disable tests because they require networking
  mvnParameters = "-DskipTests";

  installPhase = ''
    runHook preInstall
    install -m444 -D target/mariadb-java-client-${version}.jar $out/share/java/mariadb-java-client.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "MariaDB Connector/J is used to connect applications developed in Java to MariaDB and MySQL databases";
    homepage = "https://mariadb.com/kb/en/about-mariadb-connector-j/";
    changelog = "https://mariadb.com/kb/en/mariadb-connector-j-release-notes/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ anthonyroussel ];
    platforms = platforms.all;
  };
}
