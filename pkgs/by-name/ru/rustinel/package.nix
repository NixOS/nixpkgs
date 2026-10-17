{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustinel";
  version = "1.8.0";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "Karib0u";
    repo = "rustinel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mQmuAkzhQ7F3sIYCdPclQmIADaBCFY7IWC6eeiuqx9I=";
  };

  cargoHash = "sha256-KsHlay9LUWAlAKeeTEP82Sa8yzsrwcKB64qdOdS8HE8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  env = {
    RUSTC_BOOTSTRAP = 1;
    RUSTINEL_EBPF_STUB = 1;
  };

  # stateful tests that try and interact with OS
  checkFlags = [
    "--skip=normalizer::tests::populated_never_field_fails_and_increments_telemetry"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=update::tests::replaces_bundle_and_preserves_adjacent_data"
    "--skip=utils::process::macos_identity_tests::exited_process_identity_is_rejected"
    "--skip=utils::user::tests::lookup_current_effective_uid_returns_username"
    "--skip=test_reload_poller_handles_rule_tree_with_many_directories"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--skip=sensor::linux::abi::tests::embedded_object_declares_expected_abi"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Endpoint detection for Windows, Linux, and macOS with Sigma, YARA, and IOC rules on native telemetry";
    homepage = "https://github.com/Karib0u/rustinel";
    changelog = "https://github.com/Karib0u/rustinel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "rustinel";
  };
})
