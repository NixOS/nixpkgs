{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-go";
  version = "1.36.5";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    hash = "sha256-fotgvzHRRCDWRyGM9nP+BFhE0vN5/0jQlb5moOhDAWc=";
  };

  vendorHash = "sha256-nGI/Bd6eMEoY0sBwWEtyhFowHVvwLKjbT4yfzFz6Z3E=";

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
