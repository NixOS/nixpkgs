{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  installShellFiles,
  usage,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hk";
  version = "1.44.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "hk";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-PJ8RaUeHfOVWl9wwQo5sYbuo8kap8DhtcunI6XosBCg=";
  };

  cargoHash = "sha256-ag9QFqQR7idqbGKWUBpo9h6DU83Jk4YH6dzruemi0lg=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    usage
  ];

  buildInputs = [
    libgit2
    openssl
  ];

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

  postInstall = ''
    installShellCompletion --cmd hk \
      --bash <($out/bin/hk completion bash) \
      --fish <($out/bin/hk completion fish) \
      --zsh <($out/bin/hk completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A tool for managing git hooks";
    homepage = "https://hk.jdx.dev";
    changelog = "https://github.com/jdx/hk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ typedrat ];
    mainProgram = "hk";
  };
})
