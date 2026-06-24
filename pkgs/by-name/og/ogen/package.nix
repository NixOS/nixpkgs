{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ogen";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KL0wqBiUqv1deQ+agop1kRep7cCAgM+SMbkf4vkbFTA=";
  };

  vendorHash = "sha256-e2Jf6tp71bNOBBrxzEOZCRGnD6fgNzYjSEmOxiwjQ0w=";

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
