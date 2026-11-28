{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oapi-codegen";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "oapi-codegen";
    repo = "oapi-codegen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lBfYZTr3YEwVsQO8YZ+z+5nmLlB9ehJWvUrrxUHM7AU=";
  };

  vendorHash = "sha256-AgFmVUnSmstfe1l4leS+3Dt8eL3Lercj1+6MuWsjvqY=";

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
