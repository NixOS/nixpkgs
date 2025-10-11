{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  git,
  dbus,
  libudev-zero,
  installShellFiles,
  pkg-config,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stellar-cli";
  version = "22.8.1";
  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhN0DDfrIVAe7p68TnOD+M9R09+U9O62pbA6VKKuY9M";
    leaveDotGit = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+2b7FdNfCXt0DhiAOHGa0fBSraJ42DBhEJ5NznV3uK4";

  preBuild = ''
    export GIT_REVISION=$(${lib.getExe git} rev-parse HEAD)
  '';

  cargoBuildFlags = [
    "--package=stellar-cli"
  ];

  buildInputs = [
    openssl
    dbus
  ] ++ lib.optional stdenv.hostPlatform.isLinux libudev-zero;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  checkFlags =
    [
      "--skip=config::network::tests::test_helper_url_test_network"
      "--skip=config::network::tests::test_helper_url_test_network_with_path_and_param"
      "--skip=upgrade_check::tests::test_fetch_latest_stable_version"
    ]
    ++ [
      # Depend on wasm files being built by `make build-test-wasms`
      "--skip=arg_parsing::parse_i256"
      "--skip=arg_parsing::parse_enum"
      "--skip=arg_parsing::parse_enum_const"
      "--skip=arg_parsing::parse_obj"

      "--skip=help::complex_enum_help"
      "--skip=help::handle_arg_larger_than_i32_failure"
      "--skip=help::generate_help"
      "--skip=help::handle_arg_larger_than_i64_failure"
      "--skip=help::strukt_help"
      "--skip=help::multi_arg_failure"
      "--skip=help::tuple_help"
      "--skip=help::vec_help"
      "--skip=help::build"

      "--skip=plugin::list"
      "--skip=plugin::soroban_hello"
      "--skip=plugin::stellar_bye"

      "--skip=build::build_with_metadata_diff_dir"
      "--skip=build::build_with_metadata_rewrite"

      "--skip=rpc_provider::test_use_rpc_provider_with_auth_header"
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd stellar \
      --bash <($out/bin/stellar completion --shell bash) \
      --fish <($out/bin/stellar completion --shell fish) \
      --zsh <($out/bin/stellar completion --shell zsh)
  '';
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  nativeInstallCheckInputs = [ versionCheckHook ];
  meta = {
    description = "CLI for Stellar developers";
    homepage = "https://github.com/stellar/stellar-cli";
    changelog = "https://github.com/stellar/stellar-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.imartemy1524 ];
    mainProgram = "stellar";
  };
})
