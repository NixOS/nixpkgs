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
  version = "8.24.2";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = "gitleaks";
    tag = "v${version}";
    hash = "sha256-5Bx+suC24r2v9WaBzhkGJTAnh1TeQyjkVj+YVCviYOc=";
  };

  vendorHash = "sha256-MSF9N9kXsIM2WKsjKAVztYypwGPng2EElHx7p6vADqc=";

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
