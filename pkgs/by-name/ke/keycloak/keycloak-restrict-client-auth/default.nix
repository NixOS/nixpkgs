{
  maven,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-restrict-client-auth";
  version = "26.1.0";

  src = fetchFromGitHub {
    owner = "sventorben";
    repo = "keycloak-restrict-client-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nQ2AwXhSUu5RY/BbxXE2OXgEb7Zf6FfrGP5tfbgAXk8=";
  };

  mvnHash = "sha256-Q/UKZ4oe7T2pVRb8U0SoyvxUMgUn9grlDJPxlU9wLg4=";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-restrict-client-auth.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sventorben/keycloak-restrict-client-auth";
    changelog = "https://github.com/sventorben/keycloak-restrict-client-auth/releases/tag/v${finalAttrs.version}";
    description = "Keycloak authenticator to restrict authorization on clients";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
})
