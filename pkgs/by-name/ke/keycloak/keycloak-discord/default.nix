{
  maven,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "keycloak-discord";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "iForged";
    repo = "keycloak-discord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xTGXETkE5Ct+h3mYbj3VUoQhi5Wx5oZqz3G1uN0pDns=";
  };

  mvnHash = "sha256-bLGIq9wDfppYbzLT9U3E+IPTjzCiAPRCVsjBfsNvgD8=";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-discord-${finalAttrs.version}.jar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/iForged/keycloak-discord";
    changelog = "https://github.com/iForged/keycloak-discord/releases/tag/v${finalAttrs.version}";
    description = "Keycloak Identity Provider extension for Discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mkg20001
      anish
    ];
  };
})
