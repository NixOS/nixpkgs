{
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-config-cli";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "adorsys";
    repo = "keycloak-config-cli";
    tag = "v${version}";
    hash = "sha256-ZE5GYgh9iWheBt3VJEsNr7A6IzXKdmgdCyWnqqjBKrA=";
  };

  mvnHash = "sha256-MsrQHa6IksKZJjmNqS6vAsO3yZqCSoVr39rekjlESaM=";

  # Tests require either a running Keycloak instance (via Docker/Testcontainers) or the
  # GraalVM Truffle native runtime (for JavaScriptEvaluatorTest added in 6.5.0) — neither
  # is available in the Nix build sandbox.
  doCheck = false;

  # Tests use MockServer which needs to bind to a local port
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-config-cli.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/adorsys/keycloak-config-cli/";
    description = "Import YAML/JSON-formatted configuration files into Keycloak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jefferyoo
      anish
    ];
  };
}
