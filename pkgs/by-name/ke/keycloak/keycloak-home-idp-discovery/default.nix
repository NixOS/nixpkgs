{
  lib,
  fetchFromGitHub,
  maven,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-home-idp-discovery";
  version = "26.2.2";

  src = fetchFromGitHub {
    owner = "sventorben";
    repo = "keycloak-home-idp-discovery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EshNZ7COraluW7zyj6BB0yo390ms2nBbB7mCnKcOPtw=";
  };

  mvnHash = "sha256-cz5GFZ4IWTHe3o0fr1BRVRqIiutGLECuUoVl9I8gsW4=";

  # e2e tests need docker (testcontainers/selenium)
  mvnParameters = "-DskipTests";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-home-idp-discovery.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sventorben/keycloak-home-idp-discovery";
    changelog = "https://github.com/sventorben/keycloak-home-idp-discovery/releases/tag/v${finalAttrs.version}";
    description = "Keycloak authenticator to redirect users to their home identity provider by email domain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
  };
})
