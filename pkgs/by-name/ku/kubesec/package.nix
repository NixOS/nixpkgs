{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo127Module (finalAttrs: {
  pname = "kubesec";
  version = "2.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "kubesec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yWjSkIEh4KMTuPs4h/EfcRV2ChqAb0bUQesvmVVP3bA=";
  };

  vendorHash = "sha256-/3LyaHpchbuNTZ9ukLXAli7psfuqn79TDvw4TsJTqzc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X=github.com/controlplaneio/kubesec/v${lib.versions.major finalAttrs.version}/cmd.version=v${finalAttrs.version}"
  ];

  # Tests wants to download the kubernetes schema for use with kubeval
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubesec \
      --bash <($out/bin/kubesec completion bash) \
      --fish <($out/bin/kubesec completion fish) \
      --zsh <($out/bin/kubesec completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kubesec --help
    $out/bin/kubesec version | grep "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Security risk analysis tool for Kubernetes resources";
    mainProgram = "kubesec";
    homepage = "https://github.com/controlplaneio/kubesec";
    changelog = "https://github.com/controlplaneio/kubesec/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      jk
    ];
  };
})
