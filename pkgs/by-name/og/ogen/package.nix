{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ogen";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HTpjC1cgmCyJ4nqtV/F6BBsZQkkEzKwJ2KvCpcAhDRg=";
  };

  vendorHash = "sha256-z6PVOl8lPIMVsFVM304agHZNbiFCNQX4JD8R/qare9I=";

  patches = [ ./modify-version-handling.patch ];

  subPackages = [
    "cmd/ogen"
    "cmd/jschemagen"
  ];

  meta = {
    description = "OpenAPI v3 Code Generator for Go";
    homepage = "https://github.com/ogen-go/ogen";
    changelog = "https://github.com/ogen-go/ogen/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ seanrmurphy ];
    mainProgram = "ogen";
  };
})
