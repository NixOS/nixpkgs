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

buildGoModule (finalAttrs: {
  pname = "gitleaks";
  version = "8.30.1";

  src = fetchFromGitHub {
    owner = "gitleaks";
    repo = "gitleaks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PpMquYyXNN6KFwN/efY5+gr+4IhSKPoAy2M/rcqfW5k=";
  };

  vendorHash = "sha256-whJtl34dNltH/dk9qWSThcCYXC0x9PzbAUOO97Int+k=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major finalAttrs.version}/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "."
  ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    install -Dm444 config/gitleaks.toml $out/etc/gitleaks.toml
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.pname} \
      --bash <($out/bin/${finalAttrs.pname} completion bash) \
      --fish <($out/bin/${finalAttrs.pname} completion fish) \
      --zsh <($out/bin/${finalAttrs.pname} completion zsh)
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/gitleaks/gitleaks";
    changelog = "https://github.com/gitleaks/gitleaks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      friedow
    ];
    mainProgram = "gitleaks";
  };
})
