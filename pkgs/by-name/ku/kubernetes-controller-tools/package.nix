{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "controller-tools";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "controller-tools";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-BvFMLjxC5iZk9gmTgMA6ZFBHXwGzi35sz63uVB0A+xs=";
  };

  vendorHash = "sha256-eGp5KRangcOwvAEFDJrKBFZGLqB4tqK2AiltFlG4hM0=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/controller-tools/pkg/version.version=v${finalAttrs.version}"
  ];

  doCheck = false;

  subPackages = [
    "cmd/controller-gen"
    "cmd/type-scaffold"
    "cmd/helpgen"
  ];

  meta = {
    description = "Tools to use with the Kubernetes controller-runtime libraries";
    homepage = "https://github.com/kubernetes-sigs/controller-tools";
    changelog = "https://github.com/kubernetes-sigs/controller-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ michojel ];
  };
})
