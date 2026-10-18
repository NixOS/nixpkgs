{
  maven,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-orgs";
  version = "0.192";

  src = fetchFromGitHub {
    owner = "p2-inc";
    repo = "keycloak-orgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzOLb+2P9cZh7ka9DZ3BKw5DknPxBRuAVje1Ku4xq4w=";
  };

  mvnHash = "sha256-ILigQLgDTCFij4wZzbYw0fZW3XQJTqyGWs2hofr2kGk=";

  # no .git present, so give buildnumber a fallback and skip the spotless check
  mvnParameters = "-Dmaven.buildNumber.revisionOnScmFailure=v${finalAttrs.version} -DskipTests -Dspotless.check.skip=true";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out" target/keycloak-orgs-${finalAttrs.version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/p2-inc/keycloak-orgs";
    changelog = "https://github.com/p2-inc/keycloak-orgs/releases/tag/v${finalAttrs.version}";
    description = "Multi-tenancy on a single Keycloak realm via first-class organization objects";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ anish ];
  };
})
