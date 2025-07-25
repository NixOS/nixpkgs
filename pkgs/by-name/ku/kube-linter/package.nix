{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kube-linter,
}:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "kube-linter";
    rev = "v${version}";
    sha256 = "sha256-19roNwTRyP28YTIwkDDXlvsg7yY4vRLHUnBRREOe7iQ=";
  };

  vendorHash = "sha256-wCYEgQ+mm50ESQOs7IivTUhjTDiaGETogLOHcJtNfaM=";

  excludedPackages = [ "tool-imports" ];

  ldflags = [
    "-s"
    "-w"
    "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestCreateContextsWithIgnorePaths" ];

  postInstall = ''
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
    changelog = "https://github.com/stackrox/kube-linter/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mtesseract
      stehessel
      Intuinewin
    ];
    platforms = lib.platforms.all;
  };
}
