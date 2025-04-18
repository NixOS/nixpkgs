{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${version}";
    hash = "sha256-fw5nDFBlCX1HPHs9m5uJSkcfi/yUt6BN5W+igLTVepA=";
  };

  vendorHash = "sha256-6YZudsilVd4KlDGjINT9dradgkiyTPh0uJxDNMq75EY=";

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
