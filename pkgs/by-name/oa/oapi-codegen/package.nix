{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oapi-codegen";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "oapi-codegen";
    repo = "oapi-codegen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lV9U4Ojy0g0YWL8/ye6U9jL4SvPFE2Q/D0S33FBGxxU=";
  };

  vendorHash = "sha256-Oom7OcyWv+iXDb1AUsHXJ74eMYN9L7InrNuq4pfggYA=";

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
