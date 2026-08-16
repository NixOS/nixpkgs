{
  maven,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-orgs";
  version = "0.172";

  src = fetchFromGitHub {
    owner = "p2-inc";
    repo = "keycloak-orgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GAoZYOA6IiXeWcfuiz3u4JahttEfsbhG0c0SB88APk=";
  };

  mvnHash = "sha256-kU9nmiu/hWJaEfQzdVKC/IIWqZarRPpOqDP/bJQIIEY=";

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
