{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  git,
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.29.1";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = "gitleaks";
    tag = "v${version}";
    hash = "sha256-u0zKX4Hd3t/J/TfUQPT2UOM8ftXlAfirpu75ixCjh9g=";
  };

  vendorHash = "sha256-whJtl34dNltH/dk9qWSThcCYXC0x9PzbAUOO97Int+k=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  nativeCheckInputs = [ git ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/zricethezav/gitleaks";
    changelog = "https://github.com/zricethezav/gitleaks/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gitleaks";
  };
}
