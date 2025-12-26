{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  helm-ls,
}:

buildGoModule rec {
  pname = "helm-ls";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "mrjosh";
    repo = "helm-ls";
    rev = "v${version}";
    hash = "sha256-4M2o/M8mnO+9QwsjsGahY3i/pwtsNdCMCn5oCFGm0aI=";
  };

  vendorHash = "sha256-4zQy7PFC41iBVKvDRaW2zUnUzCSQmjAmyKsdnLDUHJ8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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

  meta = {
    description = "Language server for Helm";
    changelog = "https://github.com/mrjosh/helm-ls/releases/tag/v${version}";
    homepage = "https://github.com/mrjosh/helm-ls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stehessel ];
    mainProgram = "helm_ls";
  };
}
