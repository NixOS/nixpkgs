{
  stdenv,
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-2fa-email-authenticator";
  version = "26.6.5";

  src = fetchFromGitHub {
    owner = "netzbegruenung";
    repo = "keycloak-mfa-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SR0jnnS7zz0c9hyXkNw/p+fT2lfUTzHWDfpIRskSneQ=";
  };

  mvnHash =
    let
      mvnHashes = {
        "aarch64-darwin" = "sha256-D7inbJCs8r2RWY4TJMmxpiDPxy+o3xvdklzWNd5uZXk=";
        "aarch64-linux" = "sha256-DS8LfIneN05OG201CK2bIUSV0fSUdku78Vt3FIZFmwQ=";
        "x86_64-linux" = "sha256-k60cKLwN/VyWrErjIpgOvC+uYNbF2hkmCwO8MFVxvrI=";
      };
    in
    mvnHashes.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 email-authenticator/target/netzbegruenung.email-authenticator-v${finalAttrs.version}.jar \
      $out/keycloak-2fa-email-authenticator.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/netzbegruenung/keycloak-mfa-plugins";
    changelog = "https://github.com/netzbegruenung/keycloak-mfa-plugins/releases/tag/v${finalAttrs.version}";
    description = "Keycloak authentication provider for 2FA via email OTP";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anish ];
  };
})
