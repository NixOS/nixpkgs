{ lib
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage rec {
  pname = "scim-for-keycloak";
  version = "kc-20-b1"; # When updating also update mvnHash

  src = fetchFromGitHub {
    owner = "Captain-P-Goldfish";
    repo = "scim-for-keycloak";
    rev = version;
    hash = "sha256-kHjCVkcD8C0tIaMExDlyQmcWMhypisR1nyG93laB8WU=";
  };

  mvnHash = "sha256-cOuJSU57OuP+U7lI+pDD7g9HPIfZAoDPYLf+eO+XuF4=";

  installPhase = ''
    install -D "scim-for-keycloak-server/target/scim-for-keycloak-${version}.jar" "$out/scim-for-keycloak-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/Captain-P-Goldfish/scim-for-keycloak";
    description = "Third party module that extends Keycloak with SCIM functionality";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # dependencies
    ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
