{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    tag = version;
    hash = "sha256-/61AE+ywJo4ANBE+JYsS/tXJuwSuNnvB2JQIR43Gig4=";
  };

  mvnHash = "sha256-Tj+W0Dqr0FQijqYSzeAmYnbKtPZQGqry62PAZuaiGbI=";

  doCheck = false; # Requires networking

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
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ anthonyroussel ];
    platforms = platforms.all;
  };
}
