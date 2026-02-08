{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubetrim";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "kubetrim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fX8CbId2ArJlnGkevCSB7eE6Ovs8vJR9+l//k4DgvK4=";
  };

  vendorHash = "sha256-m9OuVFlD4F170Q6653HdvUhdULjR2cAttLsUN03XIXo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/alexellis/kubetrim/pkg.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Trim your KUBECONFIG automatically";
    homepage = "https://github.com/alexellis/kubetrim";
    changelog = "https://github.com/alexellis/kubetrim/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "kubetrim";
  };
})
