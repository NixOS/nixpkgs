{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kubernetes-helm }:

buildGoModule rec {
  pname = "kubernetes-helm";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-/czguDCjnQPO4bcWa9Idl9U3yzFDxL7D4P/Ia7ZzMXE=";
  };
  vendorHash = "sha256-ba5ZUpV8QHn8T1mXxY5WB0pA1OGUzmNixtwwTQFrqb4=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${src.rev}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # skipping version tests because they require dot git directory
    substituteInPlace cmd/helm/version_test.go \
      --replace "TestVersion" "SkipVersion"
    # skipping plugin tests
    substituteInPlace cmd/helm/plugin_test.go \
      --replace "TestPluginDynamicCompletion" "SkipPluginDynamicCompletion" \
      --replace "TestLoadPlugins" "SkipLoadPlugins"
    substituteInPlace cmd/helm/helm_test.go \
      --replace "TestPluginExitCode" "SkipPluginExitCode"
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    $out/bin/helm completion fish > helm.fish
    installShellCompletion helm.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = kubernetes-helm;
    command = "helm version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    mainProgram = "helm";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man techknowlogick ];
  };
}
