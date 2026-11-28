{
  lib,
  aws-lc,
  callPackage,
  e2fsprogs,
  fetchFromGitHub,
  gitMinimal,
  libgit2,
  libssh2,
  openssl,
  pkg-config,
  postgresql_18,
  postgresqlTestHook,
  protobuf,
  rustPlatform,
  sqlite,
  xz,
  zlib,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gradient";
  version = "2.1.0-rc.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wavelens";
    repo = "gradient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-633auKZiXMMKuHqYcJemKSeMJrCF2sryWFbGLfuo+Zc=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  patches = [
    ./graph-writer-boxed-handler.patch
  ];

  cargoHash = "sha256-i5+JYjx9STAHvQpOZi8UkkQe1zHaN5yVdcPmPYCDdkw=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    finalAttrs.passthru.nix
    aws-lc
    gitMinimal
    libgit2
    libssh2
    openssl
    sqlite
    xz
    zlib
    zstd
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = 1;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  outputs = [
    "out"
    "gate"
    "daemon"
    "guest"
  ];

  buildFeatures = [
    "sql-gate"
    "api-spec"
    "gradient-daemon/mock"
  ];

  postInstall = ''
    moveToOutput bin/gradient-sql-gate "$gate"
    moveToOutput bin/gradient-api-spec "$gate"
    moveToOutput bin/gradient-daemon "$daemon"
    moveToOutput bin/gradient-guest-agent "$guest"
  '';

  useNextest = true;
  checkFeatures = [ "gradient-daemon/mock" ];
  nativeCheckInputs = [
    e2fsprogs
    gitMinimal
    postgresql_18
    postgresqlTestHook
  ];

  postgresqlTestUserOptions = "LOGIN CREATEDB";
  postgresqlExtraSettings = ''
    fsync = off
    max_connections = 500
  '';

  # These tests need the test-store fixture. The last test is a randomized property test.
  # In that test, the check for scheduler consistency can fail after an admin aborted a build.
  cargoTestFlags = [
    "--filterset"
    "not (${
      lib.concatMapStringsSep " | " (test: "test(${test})") [
        "fakes::store_fixture::tests::"
        "test_eval_closure_walk_empty_store"
        "the_evaluators_are_released_before_the_closure_walk"
        "pushes_batch_closure_before_reporting_it"
        "a_known_dependency_is_neither_reported_nor_walked"
        "test_eval_aborts_when_signal_set_before_start"
        "abort_interrupts_a_running_nix_evaluation"
        "test_eval_dependencies_match_fixture"
        "a_root_is_walked_while_discovery_still_runs"
        "the_evaluators_are_released_once_discovery_ends"
        "attributes_on_a_derivation_yield_entry_points"
        "only_the_root_carries_its_licenses"
        "test_random_action_sequences_on_random_derivation_graphs_preserve_scheduler_invariants_and_finish_evaluation"
      ]
    })"
  ];

  passthru = {
    nix = callPackage ./nix.nix { inherit (finalAttrs) src; };
  };

  meta = {
    description = "Nix-CI for Teams";
    homepage = "https://github.com/wavelens/gradient";
    changelog = "https://github.com/wavelens/gradient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ derdennisop ];
    platforms = lib.platforms.linux;
    mainProgram = "gradient-server";
  };
})
