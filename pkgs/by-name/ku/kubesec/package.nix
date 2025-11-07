{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "kubesec";
    tag = "v${version}";
    hash = "sha256-4jVRd6XQekL4wMZ+Icoa2DEsTGzBISK2QPO+gu890kA=";
  };

  vendorHash = "sha256-6jXGc9tkqRTjzEiug8lGursPm9049THWlk8xY3pyVgo=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/controlplaneio/kubesec/v${lib.versions.major version}/cmd.version=v${version}"
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
    $out/bin/kubesec version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Security risk analysis tool for Kubernetes resources";
    mainProgram = "kubesec";
    homepage = "https://github.com/controlplaneio/kubesec";
    changelog = "https://github.com/controlplaneio/kubesec/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      fab
      jk
    ];
  };
}
