{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-go-hashpb";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cerbos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LUyqFN9Ahn391jS6KP0ehwfhoEXnQk0jDwdfur7t7Dw=";
  };

  vendorHash = "sha256-wCb9iyZRwAtCLB4cq0MsV6/jpD9OBolSbb72eKeIN4s=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/cerbos/protoc-gen-go-hashpb/internal/generator.Version=${version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "A protobuf plugin to generate hash functions for messages";
    homepage = "https://github.com/cerbos/protoc-gen-go-hashpb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
