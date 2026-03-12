{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  git,
  uv,
  python312,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XWUotVd6DGk8IfE5UT2NjgSB6FL/HDEBr/wBFqOMe0I=";
  };

  cargoHash = "sha256-ZIkbA6rfS+8YhfP0YE4v9Me9FeRvLVLGRBUZnoA9ids=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    git
    python312
    uv
  ];

  # many tests just do not work, as they require network access
  # best to disable all, as the upstream already tests everything
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd prek \
      --bash <(COMPLETE=bash $out/bin/prek) \
      --fish <(COMPLETE=fish $out/bin/prek) \
      --zsh <(COMPLETE=zsh $out/bin/prek)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Better `pre-commit`, re-engineered in Rust ";
    mainProgram = "prek";
    changelog = "https://github.com/j178/prek/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.knl ];
  };
})
