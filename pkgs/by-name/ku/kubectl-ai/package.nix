{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ai";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubectl-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sU8CATzhp0seUJNYjvxFkRoA/Xqb57kZqGpEOCxypUA=";
  };

  vendorHash = "sha256-OJnpd8z4e6ytoUi5ydFHYPMA77ryU7Tp8wriuab7yuk=";

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
