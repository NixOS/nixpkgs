{
  maven,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-remember-me-authenticator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Herdo";
    repo = "keycloak-remember-me-authenticator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zIFWbv02wbf3D6Weyc8N4YM+fFFxnve0ti5yS52KN3c=";
  };

  mvnHash = "sha256-Dqz6CTJaSdv0rVlzw3HzyUVkVqM4DMBrnjRMfmcK92E=";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-remember-me-authenticator-${finalAttrs.version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Herdo/keycloak-remember-me-authenticator";
    changelog = "https://github.com/Herdo/keycloak-remember-me-authenticator/releases/tag/v${finalAttrs.version}";
    description = "Custom authenticator for remembering the user logging in, even if no \"Remember me\" flag is set";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
  };
})
