{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "2.7.13";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    tag = version;
    hash = "sha256-kIGx0UHcg97kI3nWNH8x5eimWGNQLnP6T3DIIRXg1Ek=";
  };

  mvnHash = "sha256-DXftQR/V3ZfklZe/nRRZrcJxCfKPWtXBYfUyQymqmI0=";

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
