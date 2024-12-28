{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitleaks,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.22.0";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = "gitleaks";
    rev = "refs/tags/v${version}";
    hash = "sha256-f3dSKYRkXt/YT5PgFS7pclRcKvfGl2sFopqfJkEwnhw=";
  };

  vendorHash = "sha256-qjchUWWnG2CYXTM4aGkh+UgaJuPQ6yEpetXJ5ORqNuE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  # With v8 the config tests are blocking
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/zricethezav/gitleaks";
    changelog = "https://github.com/zricethezav/gitleaks/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "gitleaks";
  };
}
