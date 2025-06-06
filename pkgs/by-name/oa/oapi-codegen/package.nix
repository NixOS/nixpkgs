{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = "oapi-codegen";
    tag = "v${version}";
    hash = "sha256-21VhHSyfF+NHkXlr2svjwBNZmfS1O448POBP9XUQxak=";
  };

  vendorHash = "sha256-bp5sFZNJFQonwfF1RjCnOMKZQkofHuqG0bXdG5Hf3jU=";

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
