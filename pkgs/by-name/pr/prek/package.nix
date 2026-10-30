{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  aws-lc,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.5.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BCTJeJ8Z1QSs+nL1zUG+Xz4ql5hBEIkD91JuKnrXJxI=";
  };

  cargoHash = "sha256-R28+gp9JcFo/oP3pdg225OwVfXBR+uRyJU0EXU/A/R4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  # many tests just do not work, as they require network access
  # best to disable all, as the upstream already tests everything
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd prek \
      --bash <($out/bin/prek util generate-shell-completion bash) \
      --fish <($out/bin/prek util generate-shell-completion fish) \
      --nushell <($out/bin/prek util generate-shell-completion nushell) \
      --zsh <($out/bin/prek util generate-shell-completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Better `pre-commit`, re-engineered in Rust ";
    mainProgram = "prek";
    changelog = "https://github.com/j178/prek/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thunze ];
  };
})
