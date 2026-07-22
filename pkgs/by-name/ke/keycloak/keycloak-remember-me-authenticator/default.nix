{
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-remember-me-authenticator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Herdo";
    repo = "keycloak-remember-me-authenticator";
    tag = "v${version}";
    hash = "sha256-zIFWbv02wbf3D6Weyc8N4YM+fFFxnve0ti5yS52KN3c=";
  };

  mvnHash = "sha256-9wvBTA9RYPJz9zeimo4tmEjoHfKVGtPPAdNTe5BKdOs=";

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-remember-me-authenticator-${version}.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Herdo/keycloak-remember-me-authenticator";
    description = "Custom authenticator for remembering the user logging in, even if no \"Remember me\" flag is set";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
  };
}
