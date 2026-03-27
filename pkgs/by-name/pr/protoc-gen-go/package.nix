{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go";
  version = "1.36.11";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7+w3f5dDcQCw87A6P+JZXfMejS4QHANaLGK8QbUAaQs=";
  };

  vendorHash = "sha256-EAkrbx9pTBhZ0y0ub14PnMINrk1M6yEgnGapzpgXqBU=";

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
