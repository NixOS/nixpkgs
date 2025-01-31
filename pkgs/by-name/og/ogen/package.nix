{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${version}";
    hash = "sha256-clskb5DA1dNVKjKgtYakvshRrkeoqiwYX4QKAqSdKnE=";
  };

  vendorHash = "sha256-Ud1fg2wv+EM6h8dRO4R5SABOhPldF7uc9VwEw2/B6No=";

  patches = [ ./modify-version-handling.patch ];

  subPackages = [
    "cmd/ogen"
    "cmd/jschemagen"
  ];

  meta = {
    description = "OpenAPI v3 Code Generator for Go";
    homepage = "https://github.com/ogen-go/ogen";
    changelog = "https://github.com/ogen-go/ogen/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ seanrmurphy ];
    mainProgram = "ogen";
  };
}
