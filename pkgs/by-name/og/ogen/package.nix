{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ogen";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gVy+CZiMgjvLNn/ljOLAjpJLxTBkmEIeXbetCmsY/RY=";
  };

  vendorHash = "sha256-u9dGqPzosZnh/k48mKs0BMKjry6TI4X37rxzZyUAUjc=";

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
