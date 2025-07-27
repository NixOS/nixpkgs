{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ai";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubectl-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xxqR6jBK5RACyYGyOmIt2CY99ggWz0ygO9lmT2c0REc=";
  };

  vendorHash = "sha256-AuvBO7ucP/tWcag5NonDreXynxLm001Mu+Z1oIG8axw=";

  # Build the main command
  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/{cmd,kubectl-ai}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "AI powered Kubernetes Assistant";
    homepage = "https://github.com/GoogleCloudPlatform/kubectl-ai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "kubectl-ai";
  };
})
