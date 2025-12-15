{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kube-linter,
}:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "kube-linter";
    rev = "v${version}";
    sha256 = "sha256-wniDoImqawTdjkd/XnkeiUTMoz5WJNpRs1ZgM1Xy1hw=";
  };

  vendorHash = "sha256-ui6AECWJhYso3KDbX8EonML4wvbDs3cijG2yWb3KoKA=";

  excludedPackages = [ "tool-imports" ];

  ldflags = [
    "-s"
    "-w"
    "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
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
