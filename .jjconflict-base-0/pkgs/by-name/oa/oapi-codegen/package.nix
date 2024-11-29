{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-21VhHSyfF+NHkXlr2svjwBNZmfS1O448POBP9XUQxak=";
  } ;

  vendorHash = "sha256-bp5sFZNJFQonwfF1RjCnOMKZQkofHuqG0bXdG5Hf3jU=";

  # Tests use network
  doCheck = false;

  subPackages = [ "cmd/oapi-codegen" ];

  ldflags = [ "-X main.noVCSVersionOverride=${version}" ] ;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ j4m3s ];
    mainProgram = "oapi-codegen";
  };
}
