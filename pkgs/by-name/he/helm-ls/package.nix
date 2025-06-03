{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  helm-ls,
}:

buildGoModule rec {
  pname = "helm-ls";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mrjosh";
    repo = "helm-ls";
    rev = "v${version}";
    hash = "sha256-OxrPqDa2g5jmm+XtLE0YCnVhkvVK60xxrO49Gl8VT60=";
  };

  vendorHash = "sha256-w/BWPbpSYum0SU8PJj76XiLUjTWO4zNQY+khuLRK0O8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/helm-ls $out/bin/helm_ls
    installShellCompletion --cmd helm_ls \
      --bash <($out/bin/helm_ls completion bash) \
      --fish <($out/bin/helm_ls completion fish) \
      --zsh <($out/bin/helm_ls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = helm-ls;
    command = "helm_ls version";
  };

  meta = with lib; {
    description = "Language server for Helm";
    changelog = "https://github.com/mrjosh/helm-ls/releases/tag/v${version}";
    homepage = "https://github.com/mrjosh/helm-ls";
    license = licenses.mit;
    maintainers = with maintainers; [ stehessel ];
    mainProgram = "helm_ls";
  };
}
