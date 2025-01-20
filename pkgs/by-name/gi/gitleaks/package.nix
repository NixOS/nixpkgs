{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.23.1";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = "gitleaks";
    tag = "v${version}";
    hash = "sha256-gz/2DwkvSY6vOKW1ttJcLjjtii0jWIdQC1/xzU5vCRA=";
  };

  vendorHash = "sha256-hq3v//fhCUOvKPBZ/+YrLIc4nDLxR9Yc+MeIXY7TArA=";

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
