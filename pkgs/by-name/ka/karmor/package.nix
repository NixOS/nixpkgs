{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  karmor,
}:

buildGoModule (finalAttrs: {
  pname = "karmor";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xOI6meI88GB5w19T9eSn+8dTnhrUxUCKHUBk/1EaDVI=";
  };

  vendorHash = "sha256-FL5WL44dsM0uPYXMNfYKRd37umId21rMGvj84rYTU3A=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=1970-01-01"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=${finalAttrs.version}"
  ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    mv $out/bin/{kubearmor-client,karmor}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd karmor \
      --bash <($out/bin/karmor completion bash) \
      --fish <($out/bin/karmor completion fish) \
      --zsh  <($out/bin/karmor completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = karmor;
      command = "karmor version || true";
    };
  };

  meta = {
    description = "Client tool to help manage KubeArmor";
    mainProgram = "karmor";
    homepage = "https://kubearmor.io";
    changelog = "https://github.com/kubearmor/kubearmor-client/releases/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
