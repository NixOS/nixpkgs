{
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-secrets-vault-provider";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Nordix";
    repo = "keycloak-secrets-vault-provider";
    tag = "v${version}";
    hash = "sha256-7ttjTm3D+dDiw+00pK4yvDFNCuXFmapPKnOY7vfa2Ac=";
  };

  mvnHash = "sha256-AJwt6JnNAffXzazWI2fIUMp5j/Fm5LRhO31bOUOl7g0=";

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out/keycloak-secrets-vault-provider.jar" target/secrets-provider-${version}.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Nordix/keycloak-secrets-vault-provider";
    description = "Keycloak Vault SPI provider for OpenBao and HashiCorp Vault";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      krit
      anish
    ];
  };
}
