{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-ttrpc";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "ttrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-exDaw/hfisqEBJVuUZiOXoXiX3477Y66oaQ9UsNGLoo=";
  };

  proxyVendor = true;
  vendorHash = "sha256-78pZHRAdvl0ZQib4GVEsgLWZIfgSpneRh+Qh5xd6/ZY=";

  subPackages = [ "cmd/protoc-gen-go-ttrpc" ];

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
