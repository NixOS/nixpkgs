{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-ttrpc";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "ttrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQamR59cQrcuw9tervKrf+2vYnweRRNgST8GObFNjTk=";
  };

  proxyVendor = true;
  vendorHash = "sha256-ecEO3ZM4RWl6fXvCkncetjgUZB4+LBzSFVTgiYO3tOU=";

  subPackages = [
    "cmd/protoc-gen-go-ttrpc"
    "cmd/protoc-gen-gogottrpc"
  ];

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
  ];

  meta = {
    description = "GRPC for low-memory environments";
    homepage = "https://github.com/containerd/ttrpc";
    changelog = "https://github.com/containerd/ttrpc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      charludo
      katexochen
    ];
    mainProgram = "protoc-gen-go-ttrpc";
  };
})
