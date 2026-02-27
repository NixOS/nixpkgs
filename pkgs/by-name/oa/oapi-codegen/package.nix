{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oapi-codegen";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = "oapi-codegen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VUSqwc6TsMhry4BEj9nMkSaKg9PNMYGktwc0CA3yx6c=";
  };

  vendorHash = "sha256-vgSMGi0mnGX/Hwxu/XalIXLCbm/L4CwQfIf7DEJVk1E=";

  # Tests use network
  doCheck = false;

  subPackages = [ "cmd/oapi-codegen" ];

  ldflags = [ "-X main.noVCSVersionOverride=${finalAttrs.version}" ];

  meta = {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ j4m3s ];
    mainProgram = "oapi-codegen";
  };
})
