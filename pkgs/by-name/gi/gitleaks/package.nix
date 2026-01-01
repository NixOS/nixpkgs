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
<<<<<<< HEAD
  version = "8.30.0";
=======
  version = "8.28.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gitleaks";
    repo = "gitleaks";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nCalZlKvH3d75GKo3Qr5580kG77A2zTvsddLElYwZ8A=";
  };

  vendorHash = "sha256-whJtl34dNltH/dk9qWSThcCYXC0x9PzbAUOO97Int+k=";
=======
    hash = "sha256-smh3Ge278lYVEcs6r1F43daexgjgddy1HKhU5E4CBYM=";
  };

  vendorHash = "sha256-dd9sHt5t0s4Vff1rOwQY1OC+0FIw0SDt/cwJN+IL5D8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/version.Version=${version}"
=======
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/cmd.Version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  nativeCheckInputs = [ git ];

<<<<<<< HEAD
  postInstall = ''
    install -Dm444 config/gitleaks.toml $out/etc/gitleaks.toml
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
=======
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    homepage = "https://github.com/gitleaks/gitleaks";
<<<<<<< HEAD
    changelog = "https://github.com/gitleaks/gitleaks/releases/tag/${src.tag}";
    license = lib.licenses.mit;
=======
    changelog = "https://github.com/gitleaks/gitleaks/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      fab
      friedow
    ];
    mainProgram = "gitleaks";
  };
}
