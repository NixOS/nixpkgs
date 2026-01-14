{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  k8s-manifest-sigstore,
  gitUpdater,
}:

buildGoModule rec {
  pname = "k8s-manifest-sigstore";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "k8s-manifest-sigstore";
    rev = "v${version}";
    hash = "sha256-BDBkPXDg9DruIt5f7RrpStFeuTGiOOpsb6JiKaCTOOk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-dIReCe+Qoq/chBrd/X5s4hucuDquvd7OTUSj0WpcIDE=";

  subPackages = [ "cmd/kubectl-sigstore" ];

  ldflags =
    let
      prefix = "github.com/sigstore/k8s-manifest-sigstore/pkg/util";
    in
    [
      "-s"
      "-w"
      # https://github.com/sigstore/k8s-manifest-sigstore/blob/e740581a4652dd44eb65495ed071fd0258dcbeb4/Makefile#L22
      "-X ${prefix}.buildDate=1970-01-01T00:00:00Z"
      "-X ${prefix}.gitCommit=v${version}"
      "-X ${prefix}.gitTreeState=clean"
      "-X ${prefix}.GitVersion=v${version}"
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubectl-sigstore \
      --bash <($out/bin/kubectl-sigstore completion bash) \
      --fish <($out/bin/kubectl-sigstore completion fish) \
      --zsh <($out/bin/kubectl-sigstore completion zsh)
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.version = testers.testVersion {
      package = k8s-manifest-sigstore;
      command = "kubectl-sigstore version";
      version = "v${version}";
    };
  };

  meta = {
    homepage = "https://github.com/sigstore/k8s-manifest-sigstore";
    changelog = "https://github.com/sigstore/k8s-manifest-sigstore/releases/tag/v${version}";
    description = "Kubectl plugin for signing Kubernetes manifest YAML files with sigstore";
    mainProgram = "kubectl-sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
