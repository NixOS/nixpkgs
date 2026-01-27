{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    tag = "v${version}";
    hash = "sha256-JGGLh/1n9zG6p2/9BgfeUTKGbVuG2QnyVAdrbVvif4A=";
  };

  vendorHash = "sha256-j6WSBIPmSfbz+30wVPIbgzgghzLV0b5BYELJP6FuR/4=";

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
