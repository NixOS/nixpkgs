{
  lib,
  fetchFromGitHub,
  maven,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-magic-link";
  version = "0.75";

  src = fetchFromGitHub {
    owner = "p2-inc";
    repo = "keycloak-magic-link";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8+DRkMVhJyifXMdoxS3fPO7LPrfw2rUrZQ/zDBzLVo=";
  };

  mvnHash = "sha256-nSJvNSgo1gftGYmx0lFXHIeIhpZ+Ph1KvOHz8jF3voE=";

  # skip the spotless git check and sandbox-incompatible unit tests
  mvnParameters = "-DskipTests -Dspotless.check.skip=true";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 target/keycloak-magic-link-${finalAttrs.version}.jar $out/keycloak-magic-link-${finalAttrs.version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/p2-inc/keycloak-magic-link";
    changelog = "https://github.com/p2-inc/keycloak-magic-link/releases/tag/v${finalAttrs.version}";
    description = "Magic Link Authentication for Keycloak";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [
      lykos153
      anish
    ];
  };
})
