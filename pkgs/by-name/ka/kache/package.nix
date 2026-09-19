{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kache";
  version = "0.23.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GokpQVFfyHBrwLodVSG9chbNiJCLupzAzM31mnIGFAU=";
  };

  cargoHash = "sha256-OJ5Iqx3LelSzw6uvm7URpZeH6EeNneXzRaE2Uvhp3Lk=";

  cargoBuildFlags = [
    "-p"
    "kache"
  ];
  cargoTestFlags = [
    "-p"
    "kache"
    "--bins" # exclude integration tests
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # The tmutil xattr test shells out to /usr/bin/tmutil which isn't in the sandbox.
    "--skip=store::tests::test_exclude_from_indexing_sets_tmutil_xattr"
    # Nix's sandbox rejects sandbox_apply for these nested sandbox fixtures.
    # The regular macOS CI job runs both against real allowed/denied processes.
    "--skip=fallback::macos::tests::policy_distinguishes_denied_and_allowed_output"
    "--skip=sandbox_preflight_bypasses_denied_server_but_keeps_allowed_server"
  ];

  # planner_client / remote_backend tests bind 127.0.0.1
  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ cacert ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more";
    homepage = "https://github.com/kunobi-ninja/kache";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
