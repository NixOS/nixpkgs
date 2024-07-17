{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.0.3";
in
buildGoModule {
  inherit version;
  pname = "kubectl-validate";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubectl-validate";
    rev = "v${version}";
    hash = "sha256-k2+2QIPjNw6C/Do1WhPN39VZhZX4PZ6ZsKDKGJ9E5QA=";
  };

  vendorHash = null;

  # Disable the download tool.
  # Disable network based tests.
  preBuild = ''
    mv cmd/download-builtin-schemas/main.go cmd/download-builtin-schemas/_main.go
    mv pkg/openapiclient/github_builtins_test.go pkg/openapiclient/_github_builtins_test.go
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "kubectl-validate";
    description = "A tool for local validation of resources for native Kubernetes types and CRDs";
    homepage = "https://github.com/kubernetes-sigs/kubectl-validate";
    changelog = "https://github.com/kubernetes-sigs/kubectl-validate/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fd ];
  };
}
