{
  maven,
  lib,
  fetchFromGitHub,
}:

maven.buildMavenPackage rec {
  pname = "keycloak-restrict-client-auth";
  version = "26.1.0";

  src = fetchFromGitHub {
    owner = "sventorben";
    repo = "keycloak-restrict-client-auth";
    tag = "v${version}";
    hash = "sha256-nQ2AwXhSUu5RY/BbxXE2OXgEb7Zf6FfrGP5tfbgAXk8=";
  };

  mvnHash = "sha256-32un0gcpFI5wU9eShASzVnXmdhu3e+55iC3GBX/2yko=";

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-restrict-client-auth.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/sventorben/keycloak-restrict-client-auth";
    description = "Keycloak authenticator to restrict authorization on clients";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
}
