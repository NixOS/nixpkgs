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
  version = "0.28.1";
  __structuredAttrs = true;

  outputs = [ "out" ] ++ lib.optional stdenv.hostPlatform.isUnix "shims";

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R6VOg18TNqF4z8j2+s+i8k40croWqDs5x+z55Av5EVg=";
  };

  cargoHash = "sha256-c+7I/diStI5RL3dcSYIWxPjtllqHiBWIr9pNJjgctIs=";

  cargoBuildFlags = [
    "-p"
    "kache"
  ];
  cargoTestFlags = [
    "-p"
    "kache"
    "--bins" # exclude integration tests
  ];

  checkFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      # This test assumes reads update access times, which fails on noatime filesystems.
      "--skip=unit_prune::tests::probes_whether_reads_move_an_armed_access_time"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  postInstall = lib.optionalString stdenv.hostPlatform.isUnix ''
    mkdir -p "$shims/bin"
    for name in cc c++ gcc g++ clang clang++; do
      ln -s "$out/bin/kache" "$shims/bin/$name"
    done
    # Let another kache on PATH recognize and skip this shim directory.
    touch "$shims/bin/.kache-shims"
  '';

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more";
    homepage = "https://github.com/kunobi-ninja/kache";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
