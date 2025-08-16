{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ai";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubectl-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iyyaQBulncPNJXm7ir/aOjJxJvd0Q178weneiwQbGcU=";
  };

  vendorHash = "sha256-a84HesnInU7JZZTx0Rm1Qgsmo7SJC0kMnckgmUk0Vow=";

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
