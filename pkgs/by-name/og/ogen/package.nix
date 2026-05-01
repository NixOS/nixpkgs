{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ogen";
  version = "1.20.3";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euI+phjSa7XZyfHSLWTihWo3HM7+mdLKuSH6eNGK2xk=";
  };

  vendorHash = "sha256-I6mLFz0trnSdg4+albV7UKo0TMeFOGgDoTz3Wr0Zj7o=";

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
