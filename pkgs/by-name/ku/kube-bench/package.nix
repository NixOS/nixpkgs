{
  lib,
  buildGoModule,
  fetchFromGitHub,

  installShellFiles,

  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kube-bench";
  version = "0.11.2";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kube-bench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xIHfMJsKs66S21lsDhmj1UKuUlXKA2O7oa6Rx1pew+4=";
  };

  vendorHash = "sha256-uJv9erZcLYKYrNmVZMxgVdSa5bVKrUH8mspc4O9efhw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=v${finalAttrs.version}"
  ];

  postInstall = ''
    mkdir -p $out/share/kube-bench/
    mv ./cfg $out/share/kube-bench/

    installShellCompletion --cmd kube-bench \
      --bash <($out/bin/kube-bench completion bash) \
      --fish <($out/bin/kube-bench completion fish) \
      --zsh <($out/bin/kube-bench completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/aquasecurity/kube-bench";
    changelog = "https://github.com/aquasecurity/kube-bench/releases/tag/v${finalAttrs.version}";
    description = "Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark";
    mainProgram = "kube-bench";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
  };
})
