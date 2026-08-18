{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.4.14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zu7EGt/4GoUK02NkuCJbUBiluhHGMB/hLr/FL4oEY20=";
  };

  cargoHash = "sha256-s+l7xMf+TiEi5TgrQqP7c4SczdnFFRFpFOOVdBXAmwM=";

  nativeBuildInputs = [
    installShellFiles
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
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thunze ];
  };
})
