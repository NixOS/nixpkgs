{
  lib,
  callPackage,
  fetchFromGitHub,
  gitMinimal,
  libgit2,
  libssh2,
  openssl,
  pkg-config,
  postgresql_18,
  postgresqlTestHook,
  rustPlatform,
  sqlite,
  xz,
  zlib,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gradient";
  version = "2.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wavelens";
    repo = "gradient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hgvTiyB9lqI3FNy6x++YbZhKpYFfHVEpHJQHRGlBiOA=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  cargoHash = "sha256-3ZVd3dvj3mhPpt2/AGRvk9hs8pjgRn0K2v5F6jGKz2g=";

  # https://github.com/wavelens/gradient/pull/865
  postPatch = ''
    substituteInPlace gradient-proto/src/lib.rs \
      --replace-fail "pub mod handler;" $'#![recursion_limit = "256"]\n\npub mod handler;'
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    finalAttrs.passthru.nix
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

  useNextest = true;
  checkFeatures = [ "gradient-daemon/mock" ];
  nativeCheckInputs = [
    gitMinimal
    postgresql_18
    postgresqlTestHook
  ];

  postgresqlTestUserOptions = "LOGIN CREATEDB";
  postgresqlExtraSettings = ''
    fsync = off
    max_connections = 500
  '';

  # These tests need additional setup
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
