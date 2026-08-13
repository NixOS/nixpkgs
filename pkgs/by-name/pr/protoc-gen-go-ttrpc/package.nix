{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-ttrpc";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "ttrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B7tEuRHBMzZZ7NZ3zliFpXqtZcApDEYz6T4ZHzd4bD0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-fDq1lYp1JB5CQUOQcM1KCO0W1d37u3x22MSJCzUCYdE=";

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
