{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = "oapi-codegen";
    tag = "v${version}";
    hash = "sha256-Z10rJMancQLefyW0wXWaODIKfSY+4b3T+TAro//xsAQ=";
  };

  vendorHash = "sha256-obpY7ZATebI/7bkPMidC83xnN60P0lZsJhSuKr2A5T4=";

  # Tests use network
  doCheck = false;

  subPackages = [ "cmd/oapi-codegen" ];

  ldflags = [ "-X main.noVCSVersionOverride=${version}" ];

  meta = {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ j4m3s ];
    mainProgram = "oapi-codegen";
  };
}
