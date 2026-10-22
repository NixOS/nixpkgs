{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jarl";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "etiennebacher";
    repo = "jarl";
    tag = finalAttrs.version;
    hash = "sha256-BAhfhoDMDgcRa/ylmsyAnJmDBD0CVOkSzkb6mCUDADY=";
  };

  postPatch = ''
    # Nix sandbox uses build/.tmp as temp dir
    substituteInPlace crates/jarl/tests/integration/helpers/command_ext.rs \
    --replace-fail '(?:/private)?/(?:tmp|var/folders/[^/]+/[^/]+/T)/' \
                   '(?:/nix)?/(?:build)/(?:nix[\-0-9]+/)?'
  '';

  cargoHash = "sha256-qhwiwawHaPJCsKMfoJBlKlZ/cunUyymTvFDKwdlv3aM=";

  # integrations test require git at build time (jarl >= 0.5.0)
  nativeBuildInputs = [
    git
    installShellFiles
  ];

  # Don't run integration_tests for jarl-lsp, because it doesn't see
  # the CARGO_BIN_EXE_jarl env var even if exported in preCheck
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--test"
    "integration"
    # "--test integration_tests"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # TODO: Upstream also provides Elvish and PowerShell completions,
  # but `installShellCompletion` only has support for Bash, Zsh and Fish at the moment.
  postInstall = ''
    rm $out/bin/xtask_codegen
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jarl \
      --bash <(COMPLETE=bash $out/bin/jarl) \
      --fish <(COMPLETE=fish $out/bin/jarl) \
      --zsh <(COMPLETE=zsh $out/bin/jarl) \
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Just another R linter";
    homepage = "https://jarl.etiennebacher.com";
    changelog = "https://jarl.etiennebacher.com/changelog";
    mainProgram = "jarl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
})
