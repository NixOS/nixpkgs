{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  libgit2,
  openssl,
  usage,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hk";
  version = "1.55.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "hk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2rZhRdEvt5cAC5TrWQocgMIWhuNnCBBpjKIDE5IGNUc=";
  };

  cargoHash = "sha256-g5/F6pfvThY7S0NB0WDlpFguFBU/pH25T8dQH1WVgQA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    usage
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  # Some tests build fixture repositories by shelling out to git.
  nativeCheckInputs = [ gitMinimal ];

  # These tests require external dependencies and are fragile -- skipping.
  checkFlags = [
    "--skip=cli::init::detector::tests::test_detect_builtins_with_cargo_toml"
    "--skip=cli::init::detector::tests::test_detect_builtins_with_package_json"
    "--skip=cli::init::detector::tests::test_detect_eslint_with_contains"
    "--skip=cli::init::detector::tests::test_detect_shell_scripts"
    "--skip=cli::util::python_check_ast::tests::test_invalid_python"
    "--skip=settings::tests::test_settings_builder_fluent_api"
    "--skip=settings::tests::test_settings_from_config"
    "--skip=settings::tests::test_settings_snapshot_caching"
  ];

  cargoBuildFlags = [
    "--bin"
    "hk"
  ];

  cargoTestFlags = [ "--all-features" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hk \
      --bash <($out/bin/hk completion bash) \
      --fish <($out/bin/hk completion fish) \
      --zsh <($out/bin/hk completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for managing git hooks";
    homepage = "https://hk.jdx.dev";
    changelog = "https://github.com/jdx/hk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      typedrat
      Br1ght0ne
      sshine
    ];
    mainProgram = "hk";
  };
})
