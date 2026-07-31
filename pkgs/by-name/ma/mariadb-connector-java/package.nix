{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "mariadb-connector-java";
  version = "3.5.10";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-j";
    tag = version;
    hash = "sha256-6xdqlk+B7h19M2BxtH00u+No/znlN4qNAP0ozxy8+W8=";
  };

  mvnHash = "sha256-dX3SqMSSgk6aOtjzC/e3418KMllbD+7V/vFeaZ9fE5s=";

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
