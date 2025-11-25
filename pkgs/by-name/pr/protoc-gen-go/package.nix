{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-go";
  version = "1.36.10";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    hash = "sha256-7wAIwUouwmczSeAnA7aMmX8HwXmfnjNErgjjvx+wCZQ=";
  };

  vendorHash = "sha256-EAkrbx9pTBhZ0y0ub14PnMINrk1M6yEgnGapzpgXqBU=";

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
