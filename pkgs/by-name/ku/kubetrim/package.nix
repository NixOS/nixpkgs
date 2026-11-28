{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubetrim";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "kubetrim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uUSvLSk8GiR316CoSCY2eJo3gaa7TYhk/izHiqzLSRs=";
  };

  vendorHash = null;

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
