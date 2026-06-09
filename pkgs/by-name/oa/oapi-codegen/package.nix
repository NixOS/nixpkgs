{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oapi-codegen";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = "oapi-codegen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yfw4hb5EOYvBxl95OpUdLS+ZfCi5cHhHUf2LPS9xp0U=";
  };

  vendorHash = "sha256-ecO8nmegFAvhsvMaQ3W0wCwqbF2jUn48nSIvQGhwwcc=";

  # Tests use network
  doCheck = false;

  subPackages = [ "cmd/oapi-codegen" ];

  ldflags = [ "-X main.noVCSVersionOverride=${finalAttrs.version}" ];

  meta = {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/oapi-codegen/oapi-codegen";
    changelog = "https://github.com/oapi-codegen/oapi-codegen/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ j4m3s ];
    mainProgram = "oapi-codegen";
  };
})
