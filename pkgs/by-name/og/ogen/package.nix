{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    rev = "refs/tags/v${version}";
    hash = "sha256-SwJY9VQafclAxEQ/cbRJALvMLlnSIItIOz92XzuCoCk=";
  };

  vendorHash = "sha256-IxG7y0Zy0DerCh5DRdSWSaD643BG/8Wj2wuYvkn+XzE=";

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
