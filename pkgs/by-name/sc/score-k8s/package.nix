{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "score-k8s";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "score-spec";
    repo = "score-k8s";
    tag = finalAttrs.version;
    hash = "sha256-6kMJMRrnzChApigwM7OkxRZR1I2tZ6Fo7ePwH+JHUzE=";
  };

  vendorHash = "sha256-boqD3OhqdGe1QSGg0oKdgcQPZyI5Ec4Iq2xEbpw8SqI=";

  subPackages = [ "cmd/score-k8s" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/score-spec/score-k8s/internal/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "CLI to generate Kubernetes manifests from Score specs";
    homepage = "https://github.com/score-spec/score-k8s";
    changelog = "https://github.com/score-spec/score-k8s/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "score-k8s";
    maintainers = with lib.maintainers; [ jocelynthode ];
  };

  passthru.updateScript = nix-update-script { };
})
