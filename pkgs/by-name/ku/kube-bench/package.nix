{
  lib,
  buildGoModule,
  fetchFromGitHub,

  installShellFiles,

  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kube-bench";
  version = "0.14.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kube-bench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zu1ckblQnn3Df71myPIYebIQHjMi7S3LoSbsY8RAiVQ=";
  };

  vendorHash = "sha256-qRtEkYL+OgcfdYS+u2vRynr+6w6ZEEURxOXE/vCt2fM=";

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
