{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kube-linter,
}:

buildGoModule (finalAttrs: {
  pname = "kube-linter";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "kube-linter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JpabvLiYnDglf6rLr7HLGPafs9HHV/GZBErXr7CBQbo=";
  };

  vendorHash = "sha256-xG4RsgPOoCWFhMEMFyGKQB05O44Pm1jFo2YC8zal1Q0=";

  excludedPackages = [ "tool-imports" ];

  ldflags = [
    "-s"
    "-w"
    "-X golang.stackrox.io/kube-linter/internal/version.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestCreateContextsWithIgnorePaths" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kube-linter \
      --bash <($out/bin/kube-linter completion bash) \
      --fish <($out/bin/kube-linter completion fish) \
      --zsh <($out/bin/kube-linter completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kube-linter;
    command = "kube-linter version";
  };

  meta = {
    description = "Static analysis tool that checks Kubernetes YAML files and Helm charts";
    homepage = "https://kubelinter.io";
    changelog = "https://github.com/stackrox/kube-linter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mtesseract
      stehessel
      Intuinewin
    ];
    platforms = lib.platforms.all;
  };
})
