{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${version}";
    hash = "sha256-w3h65MNXBgsH8PCHfoPqY+XNI6TMbLUAMI4Y3WWLEJM=";
  };

  vendorHash = "sha256-PQ2ZrigS9jZY1oL3Dsuc2RZwedZLzLKUqhMYfWiZ854=";

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
